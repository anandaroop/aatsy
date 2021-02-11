class CreateAssociativeRels < ActiveRecord::Migration[6.1]
  def change
    create_table :associative_rels, comment: "The associative relationships table stores all AAT subject-to-subject relationships (other than parent/child relationships)." do |t|
      t.string :display_date, comment: "Label for relationship date information"
      t.string :end_date, comment: "Historical end date of relationship"
      t.string :historic_flag, comment: "Flag indicating the historical status of the relationship (C – Current, H – Historical, B – Both, NA - N/A, U – Undetermined)"
      t.integer :rel_type_code, null: false, comment: "Relationship type"
      t.string :start_date, comment: "Historical start date of relationship"
      t.integer :subjecta_id, null: false, comment: "ID number of first subject in the associative relationship"
      t.integer :subjectb_id, null: false, comment: "ID number of second subject in the associative relationship"
    end
  end
end
