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

def as_query(seed, ignores)
  query = seed.dup
  ignores.each { |i| query.delete(i) }
  query.symbolize_keys
end

all_seeds.each do |seeds_settings|
  model_class = seeds_settings[:class]
  seeds = seeds_settings[:seeds]
  ignores = seeds_settings[:ignore_in_query] || []

  seeds.each do |seed|
    query = as_query(seed, ignores)
    begin
      unless model = model_class.where(query).first
        model = model_class.new(seed)
        model.save!
        p "model #{model} created successfully"
      else
        p "model #{model} already existed"
      end
    rescue => e
      if model.present?
        p model
        p model.errors.messages.map {|k,v| "#{k}: #{v.to_sentence}" }.join('\n')
      else
        raise e
      end
    end
  end
end
