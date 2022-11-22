# == Schema Information
#
# Table name: static_contents
#
#  id         :bigint           not null, primary key
#  name       :string
#  key        :string
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :static_content do
    name { "MyString" }
    content { "MyString" }
  end
end
