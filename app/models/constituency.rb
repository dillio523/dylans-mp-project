# == Schema Information
#
# Table name: constituencies
#
#  id              :bigint           not null, primary key
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  constituency_id :integer
#
class Constituency < ApplicationRecord
  validates :name, presence: true
  validates :constituency_id, presence: true
end
