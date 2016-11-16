require 'faker'

FactoryGirl.define do 
	factory :user do 
		sequence(:login) { Faker::Name.first_name }
		sequence(:email) { Faker::Internet.email }
		sequence(:name) { Faker::Name.name }
		password "secret"
	end

	factory :product do
		sequence(:title) { Faker::Name.name }
		association(:user)
		sequence(:price) { Random.new.rand(1..12) * 1000 }
	end	
end	