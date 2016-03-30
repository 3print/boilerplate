root_path = File.dirname(__FILE__)
seed_pattern = File.join(root_path, 'seeds', "*.yml")

seed_files = Dir[seed_pattern]

def as_query(seed, ignores=[])
  query = seed.dup
  ignores.each { |i| query.delete(i) }
  query.symbolize_keys
end

seed_files.each do |seed_file|
  seeds_settings = YAML.load_file(seed_file).with_indifferent_access
  model_class = File.basename(seed_file, '.yml').singularize.camelize.constantize

  if seeds_settings.is_a?(Array)
    seeds = seeds_settings
    ignores = []
  else
    seeds = seeds_settings[:seeds]
    ignores = seeds_settings[:ignore_in_query]
  end

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
