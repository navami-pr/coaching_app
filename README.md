# README

This repository contains application example build into the [API on Rails 6].
A simple ruby on rails app (api only) that uses the `jsonapi-resources` gem and
postgres as a database. APIs that are compliant with the JSON API specification.
Support creating, updating, deleting, and fetching resources and relationships.


* Ruby version
  ruby 2.5.2
* Rails version
  Rails 6.1.4
  

## Setup

~~~bash
$ git clone git@github.com:navami-pr/coaching_app.git
$ cd coaching_app
$ bundle install
$ rake db:create db:migrate. db:seed
~~~  
## Features

- Rspec tests
- Code quality tools
 
`bundle exec rspec`

```
Finished in 6.76 seconds (files took 5.77 seconds to load)
37 examples, 0 failures
```
`bundle exec rubocop`

```