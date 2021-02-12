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

ActiveRecord::Schema.define(version: 2021_02_12_131205) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "associative_rels", comment: "The associative relationships table stores all AAT subject-to-subject relationships (other than parent/child relationships).", force: :cascade do |t|
    t.string "display_date", comment: "Label for relationship date information"
    t.string "end_date", comment: "Historical end date of relationship"
    t.string "historic_flag", comment: "Flag indicating the historical status of the relationship (C – Current, H – Historical, B – Both, NA - N/A, U – Undetermined)"
    t.integer "rel_type_code", null: false, comment: "Relationship type"
    t.string "start_date", comment: "Historical start date of relationship"
    t.integer "subjecta_id", null: false, comment: "ID number of first subject in the associative relationship"
    t.integer "subjectb_id", null: false, comment: "ID number of second subject in the associative relationship"
  end

  create_table "language_rels", id: false, comment: "The language relationship table contains links between terms and a controlled set of languages. In subject records, only one term can be preferred for each language in a particular subject.", force: :cascade do |t|
    t.string "language_code", null: false, comment: "Language code in language relationship"
    t.string "preferred", null: false, comment: "Flag indicating whether or not the term is preferred for the language in a particular subject record"
    t.integer "subject_id", null: false, comment: "Subject ID number in language relationship"
    t.integer "term_id", null: false, comment: "Term ID number in language relationship"
    t.string "qualifier", comment: "Label to disambiguate homophones in AAT (D – Descriptor AD – Alternate Descriptor, UF – Used For Term)"
    t.string "term_type", null: false, comment: "Term type"
    t.string "part_of_speech", null: false, comment: "Flag to indicate term part of speech for a particular language (U - Undetermined, N - Noun, PN - Plural Noun SN - Singular Noun G - Singular and Plural Gerund, PP - Past Participle VN - Verbal Noun AJ - Adjectival, NA - N/A)"
    t.string "lang_stat", null: false, comment: "Language status flag used to indicate loan terms (U - Undetermined NA - N/A, L - Loan Term )"
  end

  create_table "scope_notes", primary_key: "scope_note_id", id: { comment: "Unique ID for a scope note record" }, comment: "Descriptive notes linked to a subject record associated with a particular language", force: :cascade do |t|
    t.integer "subject_id", null: false, comment: "ID of subject record related to scope note"
    t.string "language_code", null: false, comment: "Numeric code indicating the language of the descriptive note"
    t.text "note_text", null: false, comment: "The descriptive note text"
  end

  create_table "subject_rels", id: false, comment: "The subject relationships table contains all preferred and non-preferred parent-child relationships in the AAT hierarchy.", force: :cascade do |t|
    t.string "display_date", comment: "Label for relationship date information"
    t.string "end_date", comment: "Historical end date of parent/child relationship"
    t.string "historic_flag", comment: "Flag indicating the historical status of the parent/child relationship (C – Current, H – Historical, B – Both, NA – N/A, U – Undetermined)"
    t.string "preferred", null: false, comment: "Flag indicating whether or not the parent record is preferred for a particular child (P – Preferred, N – Non-preferred)"
    t.string "rel_type", null: false, comment: "Relationship type (only parent/child currently available) (P – Parent/child)"
    t.string "start_date", comment: "Historical start date of parent/child relationship"
    t.integer "subjecta_id", null: false, comment: "ID number of parent record"
    t.integer "subjectb_id", null: false, comment: "ID number of child record"
    t.string "hier_rel_type", null: false, comment: "Hierarchical relationship type (G - Genus/Species- BTG, I - Instance-BTI, P - Whole/Part-BTP)"
  end

  create_table "subjects", primary_key: "subject_id", id: { comment: "Unique identification number of an AAT record" }, comment: "The subject table is the base table for all AAT records. An AAT record is uniquely defined by its subject ID number. The subject table stores subject-related status information and notes.", force: :cascade do |t|
    t.string "facet_code", comment: "Facet code"
    t.string "legacy_id", comment: "ID of subject record in prior system"
    t.string "merged_stat", null: false, comment: "Merge status (M – Merged N – Not merged )"
    t.integer "parent_id", comment: "Subject ID of preferred parent"
    t.string "record_type", comment: "Subject record type (C – Concept F – Facet G – Guide term H – Hierarchy name)"
    t.integer "sort_order", null: false, comment: "Sort order of subject record among preferred parent siblings.If all preferred parent sibling order numbers are 1, then the sort is alphabetical. Otherwise, the order is based on the sort order column"
    t.string "special_proj", comment: "Name of special project associated with subject record"
    t.string "ancestry"
    t.integer "ancestry_depth", default: 0
    t.string "name"
    t.index ["ancestry"], name: "index_subjects_on_ancestry"
  end

  create_table "terms", primary_key: "term_id", id: { comment: "Number identifying a unique term record" }, comment: "The term table contains the various vocabulary entries ('terms' in AAT) for each subject record. One term for each subject must be declared 'preferred' (column 'preferred' = 'P') to form the subject record's overall title or label. Each subject record must have one and only one preferred term.", force: :cascade do |t|
    t.string "aacr2_flag", comment: "Flag to indicate when a ULAN record is a AACR2 record (NA – N/A)"
    t.string "display_date", comment: "Label for term date information"
    t.string "display_name", comment: "Flag indicating whether or not the term is a display name (not used in AAT)(N/A)"
    t.integer "display_order", comment: "Order number of the term in relation to the other terms of a subject record"
    t.string "end_date", comment: "Historical end date of term use"
    t.string "historic_flag", comment: "Flag indicating the historical status of the term (B – Both, C – Current H – Historical NA – N/A)"
    t.string "other_flags", comment: "Extra field for holding any flags not already represented in the term table (not used in AAT) (N/A)"
    t.string "preferred", null: false, comment: "Flag indicating whether or not the term is the preferred form for its subject record (P – Preferred, V – Variant)"
    t.string "start_date", comment: "Historical start date of term use"
    t.integer "subject_id", null: false, comment: "ID of the subject record associated with the term"
    t.string "term", null: false, comment: "Term entry"
    t.string "vernacular", null: false, comment: "Flag indicating whether or not the term is the vernacular for a certain place (V – Vernacular, O – Other, U – Undetermined)"
  end

end
