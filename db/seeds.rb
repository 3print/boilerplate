root_path = File.dirname(__FILE__)
seed_pattern = File.join(root_path, 'seeds', "*.yml")

seed_files = Dir[seed_pattern]

def as_query(seed)
  seed.delete(:password)
  seed.delete(:password_confirmation)
end

seed_files.each do |seed_file|
  seeds = YAML.load_file(seed_file)
  model_class = File.basename(seed_file, '.yml').singularize.camelize.constantize

  seeds.each do |seed|
    begin
      unless model = model_class.where(as_query(seed)).first
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
