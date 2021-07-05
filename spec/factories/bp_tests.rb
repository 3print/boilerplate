# == Schema Information
#
# Table name: bp_tests
#
#  id            :integer          not null, primary key
#  image         :string(255)
#  pdf           :string(255)
#  int           :integer
#  json          :json
#  markdown      :text
#  text          :text
#  created_at    :datetime
#  updated_at    :datetime
#  enum          :integer
#  approved_at   :datetime
#  validated_at  :datetime
#  sequence      :integer
#  multiple_enum :integer          default([]), is an Array
#

FactoryBot.define do
  factory :bp_test do
    image { fixture_file_upload('/files/sumo.png') }
    pdf { fixture_file_upload('/files/sumo.pdf') }
    int { rand(10) }
    json { JSON.dump({"string": Faker::Lorem.sentence}) }
    markdown { Faker::Lorem.paragraph }
    text { Faker::Lorem.paragraph }
    enum { 'foo' }
    multiple_enum { ['foo', 'bar'] }
    validated_at { Time.now }
  end
end
