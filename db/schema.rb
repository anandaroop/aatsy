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

ActiveRecord::Schema.define(version: 2021_02_10_205225) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "subjects", primary_key: "subject_id", id: { comment: "Unique identification number of an AAT record" }, comment: "The subject table is the base table for all AAT records. An AAT record is uniquely defined by its subject ID number. The subject table stores subject-related status information and notes.", force: :cascade do |t|
    t.string "facet_code", comment: "Facet code"
    t.string "legacy_id", comment: "ID of subject record in prior system"
    t.string "merged_stat", null: false, comment: "Merge status (M – Merged N – Not merged )"
    t.integer "parent_key", null: false, comment: "Subject ID of preferred parent"
    t.string "record_type", comment: "Subject record type (C – Concept F – Facet G – Guide term H – Hierarchy name)"
    t.integer "sort_order", null: false, comment: "Sort order of subject record among preferred parent siblings.If all preferred parent sibling order numbers are 1, then the sort is alphabetical. Otherwise, the order is based on the sort order column"
    t.string "special_proj", comment: "Name of special project associated with subject record"
  end

end
