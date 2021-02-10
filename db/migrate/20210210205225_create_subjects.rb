class CreateSubjects < ActiveRecord::Migration[6.1]
  def change
    create_table :subjects, id: false, comment: "The subject table is the base table for all AAT records. An AAT record is uniquely defined by its subject ID number. The subject table stores subject-related status information and notes." do |t|
      t.string :facet_code, comment: "Facet code"
      t.string :legacy_id, comment: "ID of subject record in prior system"
      t.string :merged_stat, null: false, comment: "Merge status (M – Merged N – Not merged )"
      t.integer :parent_key, null: false, comment: "Subject ID of preferred parent"
      t.string :record_type, comment: "Subject record type (C – Concept F – Facet G – Guide term H – Hierarchy name)"
      t.integer :sort_order, null: false, comment: "Sort order of subject record among preferred parent siblings.If all preferred parent sibling order numbers are 1, then the sort is alphabetical. Otherwise, the order is based on the sort order column"
      t.string :special_proj, comment: "Name of special project associated with subject record"
      t.primary_key :subject_id, null: false, comment: "Unique identification number of an AAT record"
    end
  end
end
