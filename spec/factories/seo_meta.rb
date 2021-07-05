# == Schema Information
#
# Table name: seo_meta
#
#  id              :integer          not null, primary key
#  meta_owner_id   :integer
#  meta_owner_type :string
#  title           :string
#  description     :text
#  static_action   :string
#  static_mode     :boolean
#  created_at      :datetime
#  updated_at      :datetime
#

FactoryBot.define do
  factory :seo_meta do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
  end
end
