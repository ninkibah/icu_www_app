FactoryGirl.define do
  factory :user do
    email              { Faker::Internet.email }
    encrypted_password { User.encrypt_password("password", salt) }
    salt               { User.random_salt }
    icu_id             { rand(1..15000) }
    expires_on         { Date.today.next_year.at_beginning_of_year }
    status             User::OK
    verified_at        { Time.now.last_year.at_end_of_year }
    permissions        { Hash.new }
  end
end