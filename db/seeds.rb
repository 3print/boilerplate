# Seeds are a defined as a collection of hashes in a yaml file.
# The seeding task will then iterate over this collection to create a new record
# for each unless a model with the same attribute values exist in the database.
#
# By default, all the attribute present in the record hash are used to build the
# lookup query.
#
# The seed file must have the same name as the resource, meaning the underscore
# pluralized version of the model name.
#
# The seed file can have two format:
#
# * In the first format, the record list is the only content of the seed file:
#   ```yaml
#   - name: record 1
#     some_attribute: some value
#   - name: record 2
#     some_attribute: some other value
#   ```
# * In the second format, the record list is stored in a `seeds` key into a
#   hash:
#   ```yaml
#   seeds:
#     - name: record 1
#       some_attribute: some value
#     - name: record 2
#       some_attribute: some other value
#   ```
#   This second form allow to specify some additional options for the seeding
#   task.
#
#   The following options are available:
#
#   - `priority`: if you need some model to be seeded before or after some
#     other model you can use this setting to change the order in which seeds
#     are processed. Higher values appears later.
#   - `ignore_in_query`: the list of attribute names to ignore when building
#     the lookup query.
#   - `use_in_query`: the list of attribute names to use to build the query for
#     checking for model existence. If both `ignore_in_query` and `use_in_query`
#     are defined, only `use_in_query` will be used.
#   - `ignore_unknown_attributes`: When `true` the seed hash will be reaped of
#     all the fields that doesn't match a column or an association name.
#
# A seed can reference another model for a `belongs_to` association, but since
# we don't know the model id in the seed we'll have to use another method to
# find the record.
#
# The form is `find: Class#query` where `query` is a list of tuple of the field
# to match.
#
# For instance:
#
# ```yaml
# - name: 'Foo'
#   parent:
#     find: ModelClass#field_a=value_a,field_b=value_b
# ```


def association_columns(object, *by_associations)
  if object.respond_to?(:reflections)
    object.reflections.collect do |name, association_reflection|
      if by_associations.present?
        if by_associations.include?(association_reflection.macro) && association_reflection.options[:polymorphic] != true
          name.to_s
        end
      else
        name.to_s
      end
    end.compact
  else
    []
  end
end

def polymorphic_association_columns(object)
  if object.respond_to?(:reflections)
    object.reflections.collect do |name, association_reflection|
      if association_reflection.options[:polymorphic]
        name.to_s
      end
    end.compact
  else
    []
  end
end

def content_columns(object)
  return [] unless object.respond_to?(:content_columns)
  object.content_columns.collect { |c| c.name }.compact
end

def all_columns(object)
  content_columns(object) + association_columns(object)
end

def seeds_paths
  root_path = File.dirname(__FILE__)
  seed_pattern = File.join(root_path, 'seeds', "*.yml")
  Dir[seed_pattern]
end

def all_seeds
  seeds_paths.map do |f|
    settings = YAML.load_file(f).with_indifferent_access
    if settings.is_a?(Array)
      settings = {
        seeds: settings,
        ignore_in_query: []
      }
    end

    settings[:file] = f
    settings[:class] = File.basename(f, '.yml').classify.constantize
    settings

  end.sort {|a,b| (a[:priority] || 0) - (b[:priority] || 0) }
end

def as_query(model_class, seed, ignores, uses)
  belongs_to_associations = association_columns(model_class, :belongs_to)
  polymorphic_belongs_to_associations = polymorphic_association_columns(model_class)
  query = seed.dup

  if uses.present?
    query = Hash[query.select {|k,v| uses.include?(k) }]
  else
    ignores.each { |i| query.delete(i) }
  end

  Hash[query.map do |k,v|
    if belongs_to_associations.include?(k)
      ["#{k}_id", v.try(:id)]
    elsif polymorphic_belongs_to_associations.include?(k)
      [
        ["#{k}_id", v.try(:id)],
        ["#{k}_type", v.try(:class).try(:name)]
      ]
    elsif model_class.defined_enums.has_key?(k)
      [k, model_class.send(k.to_s.pluralize)[v]]
    else
      [k, v]
    end
  end].symbolize_keys
end

def cleanup_attributes(model_class, attrs)
  instance = model_class.new

  Hash[attrs.select { |k,v| instance.respond_to?(:"#{k}=") }].with_indifferent_access
end

def process_attributes(attrs)
  Hash[attrs.map do |k,v|
    if v.is_a?(Hash) && v.has_key?(:find)
      m,t = v['find'].split('#')
      l = t.split(',')
      q = {}
      l.each do |ll|
        a,vv = ll.split('=')
        q[a] = vv
      end

      v = m.constantize.where(q).first
    end

    [k,v]
  end]
end

all_seeds.each do |seeds_settings|
  model_class = seeds_settings[:class]
  seeds = seeds_settings[:seeds]
  ignores = seeds_settings[:ignore_in_query] || []
  uses = seeds_settings[:use_in_query] || []

  print "\n------------ #{model_class} ------------\n"

  seeds.each do |seed|
    if seeds_settings[:ignore_unknown_attributes]
      seed = cleanup_attributes(model_class, seed)
    end
    seed = process_attributes(seed)

    query = as_query(model_class, seed, ignores, uses)
    begin
      unless model = model_class.where(query).first
        ActiveRecord::Base.transaction do
          model = model_class.new(seed)
          model.save!
        end
        print "model #{model} created successfully\n"
      else
        print "model #{model} already existed\n"
      end
    rescue => e
      if model.present?
        p model
        if model.errors.any?
          p model.errors.messages.map {|k,v| "#{k}: #{v.to_sentence}" }.join('\n')
        else
          p e
        end

      else
        raise e
      end
    end
  end
end
