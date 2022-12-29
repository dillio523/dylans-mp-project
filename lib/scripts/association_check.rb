# to see if any instances of postcodes arent associated with a constituency
# no_constituency_count = Postcode.where(constituency_id: nil).count
# puts "Number of postcodes without a constituency: #{no_constituency_count}"
# postcodes = Postcode.where(constituency_id: nil).limit(5)

# # Iterate through the postcodes and print the postcode for each one
# postcodes.each do |postcode|
#   puts postcode.postcode
# end

# # see number of postcodes for each consituency
# Constituency.all.each do |constituency|
#   postcode_count = constituency.postcodes.count
#   puts "#{constituency.name} has #{postcode_count} postcodes associated with it"
# end

# see number of postcodes without constit name
# no_constit_name_count = Postcode.where(constituency_name: nil).count
# puts "Number of postcodes without a constituency name: #{no_constit_name_count}"
no_constituency_count = Member.joins(:constituency).where(constituencies: { id: nil }).count
puts "Number of members without a constituency association: #{no_constituency_count}"
