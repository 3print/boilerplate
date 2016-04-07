
require 'seeder'

root_path = File.dirname(__FILE__)
seed_pattern = File.join(root_path, 'seeds', "*.yml")

Seeder.new(Dir[seed_pattern]).load
