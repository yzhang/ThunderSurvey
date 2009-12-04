# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

user = User.create(:email => 'admin@example.com', 
                    :password => 'password', 
                    :password_confirmation => 'password', 
                    :name => 'Administrator')
user.activate!
role = Role.create(:title => 'superuser')
user.roles << role
