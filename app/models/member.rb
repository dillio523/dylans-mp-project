# == Schema Information
#
# Table name: members
#
#  id                          :bigint           not null, primary key
#  gender                      :string
#  house                       :integer
#  membership_end_date         :datetime
#  membership_end_reason       :string
#  membership_end_reason_notes :string
#  membership_from             :string
#  membership_start_date       :datetime
#  membership_status           :boolean
#  name_address_as             :string
#  name_display_as             :string
#  name_full_title             :string
#  name_list_as                :string
#  party                       :string
#  status_description          :string
#  status_notes                :string
#  status_start_date           :datetime
#  thumbnail_url               :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  membership_end_reason_id    :integer
#  membership_from_id          :integer
#  status_id                   :integer
#
class Member < ApplicationRecord
  
end
