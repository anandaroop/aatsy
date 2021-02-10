class CreateSubjectRels < ActiveRecord::Migration[6.1]
  def change
    create_table :subject_rels, id: false, comment: "The subject relationships table contains all preferred and non-preferred parent-child relationships in the AAT hierarchy." do |t|
      t.string :display_date, comment: "Label for relationship date information"
      t.string :end_date, comment: "Historical end date of parent/child relationship"
      t.string :historic_flag, comment: "Flag indicating the historical status of the parent/child relationship (C – Current, H – Historical, B – Both, NA – N/A, U – Undetermined)"
      t.string :preferred, null: false, comment: "Flag indicating whether or not the parent record is preferred for a particular child (P – Preferred, N – Non-preferred)"
      t.string :rel_type, null: false, comment: "Relationship type (only parent/child currently available) (P – Parent/child)"
      t.string :start_date, comment: "Historical start date of parent/child relationship"
      t.integer :subjecta_id, null: false, comment: "ID number of parent record"
      t.integer :subjectb_id, null: false, comment: "ID number of child record"
      t.string :hier_rel_type, null: false, comment: "Hierarchical relationship type (G - Genus/Species- BTG, I - Instance-BTI, P - Whole/Part-BTP)"
    end
  end
end
