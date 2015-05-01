# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150428232546) do

  create_table "actuations", force: true do |t|
    t.integer  "flavor_id"
    t.integer  "behavior_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "actuators", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture"
  end

  create_table "assignments", force: true do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.boolean  "completed",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "behavior_links", force: true do |t|
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "behavior_id"
    t.string   "sequence_id"
  end

  create_table "behaviors", force: true do |t|
    t.string   "name"
    t.float    "notification"
    t.float    "active"
    t.float    "unable"
    t.float    "low_energy"
    t.float    "turning_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "states"
    t.boolean  "is_smooth",    default: false
    t.boolean  "is_library",   default: false
  end

  create_table "commands", force: true do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.text     "code",       limit: 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_streams", force: true do |t|
    t.string   "api_name"
    t.string   "api_url"
    t.string   "api_params"
    t.string   "api_response"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "experiments", force: true do |t|
    t.integer  "actuator_id"
    t.string   "physical_mag"
    t.string   "subjective_mag"
    t.string   "stimulus_cond"
    t.string   "continuum"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fiddle_codes", force: true do |t|
    t.text     "code",       limit: 2147483647
    t.string   "editor"
    t.integer  "user_id"
    t.integer  "stl_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "flavors", force: true do |t|
    t.float    "alpha"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "img"
    t.integer  "actuator_id"
    t.string   "name"
  end

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true, using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "mappers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "multiples", force: true do |t|
    t.integer  "user_id"
    t.integer  "stl_id"
    t.text     "fv",         limit: 2147483647
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "neighbors", force: true do |t|
    t.integer  "part_id"
    t.integer  "sibling_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parts", force: true do |t|
    t.string   "name"
    t.text     "faces",              limit: 2147483647
    t.integer  "stl_id"
    t.integer  "parent_id"
    t.datetime "created_at",                                                             null: false
    t.datetime "updated_at",                                                             null: false
    t.float    "volume",                                default: 0.0
    t.string   "pca1",                                  default: "---\n- 1\n- 0\n- 0\n"
    t.string   "pca2",                                  default: "---\n- 0\n- 1\n- 0\n"
    t.string   "pca3",                                  default: "---\n- 0\n- 0\n- 1\n"
    t.integer  "neighbor_id"
    t.boolean  "neighbors_computed",                    default: false
  end

  add_index "parts", ["stl_id"], name: "index_parts_on_stl_id", using: :btree

  create_table "phylas", force: true do |t|
    t.string  "name"
    t.string  "subphyla"
    t.integer "count"
  end

  create_table "schemes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "sequence_links", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sequences", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "stls", force: true do |t|
    t.string   "name"
    t.integer  "author"
    t.string   "stl_path"
    t.string   "segmentation_path"
    t.string   "img"
    t.string   "img_thumb"
    t.integer  "times_used"
    t.integer  "phyla_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.float    "rotate_x",          default: 0.0
    t.float    "rotate_y",          default: 0.0
    t.float    "rotate_z",          default: 0.0
    t.string   "ascii"
    t.string   "binary"
    t.string   "slug"
  end

  add_index "stls", ["slug"], name: "index_stls_on_slug", unique: true, using: :btree

  create_table "stories", force: true do |t|
    t.string   "title"
    t.string   "author"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "story_images", force: true do |t|
    t.string   "file"
    t.string   "size"
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "story_page_id"
  end

  create_table "story_pages", force: true do |t|
    t.string   "storytype"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "story_id"
    t.integer  "page_number"
  end

  create_table "story_texts", force: true do |t|
    t.string   "text"
    t.integer  "fontSize"
    t.string   "center"
    t.string   "textBackgroundHex"
    t.float    "textBackgroundAlpha"
    t.integer  "border"
    t.string   "story_page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.integer  "behavior_id"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
