#!/usr/bin/env ruby
=begin
THIS SCRIPT IS USEFUL TO GENERATE A NEW JSON WITH ENTI'S DATA GROUPED BY ORG-NAME
=end
require 'json'

file = File.read('./_data/visible-services.json')
data_hash = JSON.parse(file)
entisearchable = {}
Jekyll::Hooks.register :site, :after_init do |doc, payload|
    data_hash.each do |key, value|
        service = {value['serviceId'] => value['serviceName'] }
        if entisearchable.key?(value['organizationName'])
            entisearchable[value['organizationName']][:s].push(service)
        else
            entisearchable[value['organizationName']] = {:o => value['organizationName'], :s => [service]}
        end
    end
    entisearchable_sorted = entisearchable.sort.to_h
    File.write('./assets/json/servizi-ricercabili.json', JSON.dump(entisearchable_sorted.values))
end