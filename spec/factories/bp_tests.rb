# == Schema Information
#
# Table name: bp_tests
#
#  id             :integer          not null, primary key
#  image          :string
#  pdf            :string
#  int            :integer
#  json           :json
#  markdown       :text
#  text           :text
#  created_at     :datetime
#  updated_at     :datetime
#  enum           :integer
#  approved_at    :datetime
#  validated_at   :datetime
#  sequence       :integer
#  multiple_enum  :integer          default([]), is an Array
#  image_gravity  :integer
#  image_alt_text :string
#  visual         :string
#  visual_regions :json
#
include FixturesHelper::ExampleMethods

FactoryBot.define do

  factory :bp_test do

    image { fixture_file_upload('sumo.png') }
    pdf { fixture_file_upload('sumo.pdf') }
    int { rand(10) }
    json { JSON.dump({"string": Faker::Lorem.sentence}) }
    markdown { Faker::Lorem.paragraph }
    text { Faker::Lorem.paragraph }
    enum { 'foo' }
    multiple_enum { ['foo', 'bar'] }
    validated_at { Time.now }
  end
end
