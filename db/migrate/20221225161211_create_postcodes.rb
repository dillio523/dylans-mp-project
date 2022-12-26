class CreatePostcodes < ActiveRecord::Migration[7.0]
  def change
    create_table :postcodes do |t|
      t.string :pcds
      t.string :pcon

      t.timestamps
    end
  end
end
