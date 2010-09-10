require 'rubygems'
require 'sinatra'

gem 'jnunemaker-rack-gridfs'
require 'rack/gridfs'

use Rack::GridFS, :hostname => 'localhost', :port => 27017, :database => 'testing', :prefix => 'gridfs'

db = Mongo::Connection.new.db('testing')
id = Mongo::Grid.new(db).put(File.read('mr_t.jpg'), 'mr_t.jpg')

get /.*/ do
  %Q(Maybe you should look at <a href="/gridfs/#{id}">this file</a>)
end