# == Schema Information
#
# Table name: bp_tests
#
#  id           :integer          not null, primary key
#  image        :string(255)
#  pdf          :string(255)
#  int          :integer
#  json         :json
#  markdown     :text
#  text         :text
#  created_at   :datetime
#  updated_at   :datetime
#  enum         :string(255)
#  approved_at  :datetime
#  validated_at :datetime
#

FactoryGirl.define do
  factory :bp_test do
    image { fixture_file_upload('/files/sumo.png') }
    pdf { fixture_file_upload('/files/sumo.pdf') }
    int { rand(10) }
    json { JSON.dump({"string": Faker::Lorem.sentence}) }
    markdown { Faker::Lorem.paragraph }
    text { Faker::Lorem.paragraph }
    enum { 'foo' }
    validated_at { Time.now }
  end
end
