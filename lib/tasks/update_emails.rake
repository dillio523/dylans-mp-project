namespace :members do
  require 'net/http'
  require 'json'

  desc "Update the emails for all members"
  task update_emails: :environment do
    members = Member.all
    members.each do |member|
      url = URI("https://members-api.parliament.uk/api/Members/#{member.member_id}/Contact")
      response = Net::HTTP.get(url)
      data = JSON.parse(response)
      data['value'].each do |item|
        if item['type'] == 'Parliamentary office'
          member.email = item['email']
          break
        end
      end
      member.save
    end
  end
end
