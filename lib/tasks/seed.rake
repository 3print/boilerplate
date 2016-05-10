require 'seeder'

Rake::Task["db:seed"].clear

namespace :db do
  task seed: :environment do
    model_collection = ENV['model'] || '*'

    seed_pattern = File.join(Rails.root, 'db', 'seeds', "#{model_collection}.yml")

    Seeder.new(Dir[seed_pattern]).load

    if model_collection == 'stores'
      Store.all.each { |s| s.create_default_pages! }
    end
  end
end
