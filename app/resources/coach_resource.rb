class CoachResource < JSONAPI::Resource
  attributes :name
  has_one :course, exclude_links: :default

  exclude_links :default

  before_remove :tranfer_account
end
