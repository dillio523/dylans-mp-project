# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_12_26_160827) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "constituencies", force: :cascade do |t|
    t.string "name"
    t.integer "constituency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "seat_vacant"
  end

  create_table "members", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_display_as"
    t.string "party"
    t.string "gender"
    t.integer "constituency_id"
    t.integer "house"
    t.datetime "membership_start_date"
    t.string "thumbnail_url"
    t.integer "party_id"
    t.integer "member_id"
  end

  create_table "postcodes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "postcode"
    t.float "latitude"
    t.float "longitude"
    t.string "county"
    t.string "district"
    t.string "ward"
    t.integer "population"
    t.string "region"
    t.string "constituency_code"
    t.integer "index_of_multiple_deprivation"
    t.float "distance_to_station"
    t.float "average_income"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
