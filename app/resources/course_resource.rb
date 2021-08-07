class CourseResource < JSONAPI::Resource
  attributes :name, :self_assignable
  has_many :activities, exclude_links: :default

  exclude_links :default

  filters :self_assignable
end
