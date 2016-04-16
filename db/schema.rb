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

ActiveRecord::Schema.define(version: 20160309193422) do

  create_table "genres", force: :cascade do |t|
    t.integer  "genre_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movies", force: :cascade do |t|
    t.integer  "tmdb_id"
    t.string   "title"
    t.string   "director"
    t.string   "producer"
    t.string   "screenwriter"
    t.string   "actors"
    t.string   "genre"
    t.float    "vote_average"
    t.integer  "vote_count"
    t.float    "popularity"
    t.integer  "runtime"
    t.integer  "release_date"
    t.string   "overview"
    t.string   "certification"
    t.string   "poster_path"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.integer  "tmdb_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.integer  "movie_id"
    t.integer  "person_id"
    t.integer  "tmdb_id"
    t.string   "character"
    t.string   "job"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end