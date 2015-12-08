FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password "please123"
    password_confirmation "please123"

    trait :admin do
      role 'admin'
    end

    trait :no_password do
      password nil
      password_confirmation nil
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
