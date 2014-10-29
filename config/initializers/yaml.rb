module YAML
  def YAML.include file_name
    require 'erb'
    unless file_name =~ /^\//
      file_name = File.expand_path("config/locales/#{file_name}", Rails.root)
    end
    ERB.new(IO.read(file_name)).result
  end

  def YAML.load_file file_name
    YAML::load(YAML::include(file_name))
  end
end
