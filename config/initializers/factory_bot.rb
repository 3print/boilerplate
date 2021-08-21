Rails.application.reloader.to_prepare do
  Dir[Rails.root.join("spec", "support", "helpers", "*.rb")].sort.each { |f| require f }
end
