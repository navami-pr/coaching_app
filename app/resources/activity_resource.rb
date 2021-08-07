class ActivityResource < JSONAPI::Resource
  attributes :name

  exclude_links :default
end
