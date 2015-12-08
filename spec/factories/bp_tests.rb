FactoryGirl.define do
  factory :bp_test do
    image "MyString"
    int 1
    json '{"string": "MyString"}'
    markdown "MyText"
    text "MyText"
  end
end
