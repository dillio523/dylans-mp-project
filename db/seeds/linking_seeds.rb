require 'csv'
require 'activerecord-import'
require 'smarter_csv'

def link_postcodes_to_constituencies
  # Get all postcodes that have a non-empty constituency name
  puts "Starting postcode linking..."
  # Use a single update query to update all postcodes at once
  Postcode.where("constituency_name != ''").update_all("constituency_id = (SELECT constituency_id FROM constituencies WHERE LOWER(name) = LOWER(postcodes.constituency_name))")
  puts "finished linking"
end
