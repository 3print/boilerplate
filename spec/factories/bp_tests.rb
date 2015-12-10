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
    image "MyString"
    int 1
    json '{"string": "MyString"}'
    markdown "MyText"
    text "MyText"
  end
end
