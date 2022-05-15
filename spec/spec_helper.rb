require 'rspec'
require 'pg'
require 'album'
require 'song'
require 'artist'
require 'pry'

# shared code for clearing tests between runs & connecting to the DB:

DB = PG.connect({:dbname => 'record_store_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM albums *;")
    DB.exec("DELETE FROM songs *;")
    DB.exec("DELETE FROM artists *;")
  end
end