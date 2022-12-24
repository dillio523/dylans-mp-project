# == Schema Information
#
# Table name: members
#
#  id                    :bigint           not null
#  gender                :string
#  house                 :integer
#  membership_start_date :datetime
#  name_display_as       :string
#  party                 :string
#  thumbnail_url         :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  constituency_id       :integer
#  member_id             :integer          primary key
#  party_id              :integer
#
class Member < ApplicationRecord
  self.primary_key = :member_id
  belongs_to :constituency
end
