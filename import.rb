#!/usr/bin/env ruby
require 'json'
require 'algoliasearch'
require 'awesome_print'
require 'open-uri'
require 'net/http'

####
#### SCRIPT PARAMETERS
####
if ARGV.length != 3
    $stderr << "usage: import.rb APP_ID API_KEY INDEX\n"
    exit 1
end
APP_ID  = ARGV[0]
API_KEY = ARGV[1]
INDEX   = ARGV[2]
INDEX_TMP = "#{INDEX}_tmp"

####
#### INIT ALGOLIA
####
Algolia.init application_id: APP_ID, api_key: API_KEY

####
#### LOAD DATA
####
airports = File.read('/Users/wyattkim/Desktop/trails_new-2.csv').split("\n")
records = {}
airports.each do |airport|
    data = airport.split(',').map { |value| value.delete('"') }
    id, name, forest, status, lng, lat, description, distance, elevation, difficulty, number, type = data
    id = id.to_i
    lat = lat.to_f
    lng = lng.to_f
    distance = distance.to_f
    elevation = elevation.to_i
    
    
    records[id] = {
        objectID: id,
        name: name,
        forest: forest,
        status: status,
        _geoloc: {
            lat: lat,
            lng: lng
        },
        description: description,
        distance: distance,
        elevation: elevation,
        difficulty: difficulty,
        number: number,
        type: type,
        users: []
    }
end

####
#### PUSH TO ALGOLIA
####
puts "Pushing #{records.size} records to #{INDEX}"

index = Algolia::Index.new INDEX_TMP
index.set_settings(attributesToIndex: %w(objectID name status _geoloc description, distance, elevation, difficulty, number, type),
                   removeWordsIfNoResults: 'allOptional',
                   typoTolerance: 'min')
records.each_slice(1) do |batch|
    trail = batch[0]
    actualTrail = trail[1]
    
    index.add_object(actualTrail)
    puts "added trail"
end
Algolia.move_index(INDEX_TMP, INDEX)
puts "#{records.size} records pushed!"
