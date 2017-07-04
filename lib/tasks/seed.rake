require 'sumo_seed'

Rake::Task["db:seed"].clear

namespace :db do
  task seed: :environment do
    SumoSeed.run_task
  end
end
