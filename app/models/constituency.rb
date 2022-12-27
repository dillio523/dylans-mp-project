# == Schema Information
#
# Table name: constituencies
#
#  id              :bigint           not null
#  name            :string
#  seat_vacant     :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  constituency_id :string           primary key
#
class Constituency < ApplicationRecord
  # validates :name, presence: true
  # validates :constituency_id, presence: true
  self.primary_key = :constituency_id
  has_one :member, dependent: :destroy
  has_many :postcodes
end
