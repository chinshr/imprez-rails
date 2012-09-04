# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

template = Presentation::Template.new(:root => "templates/sample", :html => "index.html")
html     = template.contents

Presentation.find_or_create_by_name "Simple Template", {
  body: html
} {|p| p.template = true}
