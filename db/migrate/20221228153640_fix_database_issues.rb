class FixDatabaseIssues < ActiveRecord::Migration[7.0]
  def change
    # implemented suggested changes from database consistency checker,
    # Change the type of the member_id and constituency_id columns to bigint
    change_column :members, :member_id, :bigint
    change_column :constituencies, :constituency_id, 'bigint USING CAST(constituency_id AS bigint)'

    # Add a foreign key constraint for the constituency_id column in the postcodes table
    add_foreign_key :postcodes, :constituencies, column: :constituency_id

    # Add a foreign key constraint for the constituency_id column in the members table
    add_foreign_key :members, :constituencies, column: :constituency_id

    # Add a unique index for the member_id column in the members table
    add_index :members, :member_id, unique: true

    # Add an index for the postcodes table
    add_index :postcodes, :constituency_id

    # Make the constituency_id column in the postcodes table required
    change_column_null :postcodes, :constituency_id, false

    # Make the constituency_id column in the members table required
    change_column_null :members, :constituency_id, false
  end
end
