require 'faker'


30.times {
    Coach.create( name: Faker::Name.name)
}

20.times {
    Course.create({
        name: Faker::Name.name,
        self_assignable: true,
        coach: Coach.limit(1).order("RANDOM()").first # sql random
    })
}
20.times {
    Course.create({
        name: Faker::Name.name,
        self_assignable: false,
        coach: Coach.limit(1).order("RANDOM()").first # sql random
    })
}
20.times {
    Activity.create({
        name: Faker::Name.name,
        course: Course.limit(1).order("RANDOM()").first # sql random
    })
}