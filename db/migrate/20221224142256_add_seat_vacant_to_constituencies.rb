class AddSeatVacantToConstituencies < ActiveRecord::Migration[7.0]
  def change
    add_column :constituencies, :seat_vacant, :boolean
  end
end

