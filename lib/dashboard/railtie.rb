class Dashboard
  class Railtie < Rails::Railtie
    config.after_initialize do
      paths = Rails.application.paths['app/models'].to_a
      Rails.application.railties.each do |tie|
        next unless tie.respond_to? :paths
        paths += tie.paths['app/models'].to_a
      end

      paths.each do |path|
        next unless File.directory?(path)
        Dir.chdir path do
          Dir['**/*.rb'].each do |src|
            TPrint.debug "loading #{src[0..-4].classify}"
            src[0..-4].classify.constantize rescue nil
          end
        end
      end
    end
  end
end
