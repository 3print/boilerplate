# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string
#  last_name              :string
#  role                   :integer
#  avatar                 :string
#  avatar_meta            :text
#  avatar_gravity         :integer
#  password_changed_at    :datetime
#  locked_at              :datetime
#  failed_attempts        :integer
#  unlock_token           :string
#

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { "please123" }
    password_confirmation { "please123" }

    trait :admin do
      role { 'admin' }
    end

    trait :no_password do
      password { nil }
      password_confirmation { nil }
    end
    (User.roles.keys - ["user"]).each do |k|
      factory k do
        after(:build) do |u|
          u.role = k
        end
      end
    end
  end
end
