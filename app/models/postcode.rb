# == Schema Information
#
# Table name: postcodes
#
#  id                            :bigint           not null, primary key
#  average_income                :float
#  constituency_code             :string
#  constituency_name             :string
#  county                        :string
#  distance_to_station           :float
#  district                      :string
#  index_of_multiple_deprivation :integer
#  latitude                      :float
#  longitude                     :float
#  population                    :integer
#  postcode                      :string
#  region                        :string
#  ward                          :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  constituency_id               :integer
#
class Postcode < ApplicationRecord
  belongs_to :constituency, foreign_key: :constituency_id
end
