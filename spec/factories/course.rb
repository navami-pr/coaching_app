FactoryBot.define do
  factory :course do
    name { Faker::Name.name }
    self_assignable { Faker::Boolean }
    coach { create(:coach) }
  end
end
