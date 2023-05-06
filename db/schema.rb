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

ActiveRecord::Schema[7.0].define(version: 2023_05_06_025318) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gin"
  enable_extension "btree_gist"
  enable_extension "citext"
  enable_extension "cube"
  enable_extension "dblink"
  enable_extension "dict_int"
  enable_extension "dict_xsyn"
  enable_extension "earthdistance"
  enable_extension "fuzzystrmatch"
  enable_extension "hstore"
  enable_extension "intarray"
  enable_extension "ltree"
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "pgrowlocks"
  enable_extension "pgstattuple"
  enable_extension "plpgsql"
  enable_extension "tablefunc"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"
  enable_extension "xml2"

  create_table "couples", force: :cascade do |t|
    t.integer "tree1_id"
    t.integer "tree2_id"
    t.date "marriage"
    t.date "separation"
    t.text "local"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "couples_trees", id: false, force: :cascade do |t|
    t.bigint "tree_id", null: false
    t.bigint "couple_id", null: false
    t.index ["couple_id"], name: "index_couples_trees_on_couple_id"
    t.index ["tree_id"], name: "index_couples_trees_on_tree_id"
  end

  create_table "trees", force: :cascade do |t|
    t.string "name"
    t.integer "gender"
    t.boolean "alive", default: true
    t.date "birth"
    t.date "death"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
