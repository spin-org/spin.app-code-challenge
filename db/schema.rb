# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_07_181727) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.string "timezone"
  end

  create_table "scooter_state_changes", force: :cascade do |t|
    t.integer "scooter_id"
    t.string "attr_changed"
    t.string "original_value"
    t.string "new_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scooter_id"], name: "index_scooter_state_changes_on_scooter_id"
  end

  create_table "scooters", force: :cascade do |t|
    t.string "uid"
    t.integer "city_id"
    t.float "charge_percent"
    t.boolean "under_maintenance", default: false
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lonlat"], name: "index_scooters_on_lonlat", using: :gist
    t.index ["uid"], name: "index_scooters_on_uid", unique: true
  end

end
