FactoryBot.define do
  factory :activity do
    name { Faker::Name.name }
    course { create(:course) }
  end
end
