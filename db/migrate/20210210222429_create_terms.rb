class CreateTerms < ActiveRecord::Migration[6.1]
  def change
    create_table :terms, id: false, comment: "The term table contains the various vocabulary entries ('terms' in AAT) for each subject record. One term for each subject must be declared 'preferred' (column 'preferred' = 'P') to form the subject record's overall title or label. Each subject record must have one and only one preferred term." do |t|
      t.string :aacr2_flag, comment: "Flag to indicate when a ULAN record is a AACR2 record (NA – N/A)" # NA
      t.string :display_date, comment: "Label for term date information" #
      t.string :display_name, comment: "Flag indicating whether or not the term is a display name (not used in AAT)(N/A)" # NA
      t.integer :display_order, comment: "Order number of the term in relation to the other terms of a subject record" # 3
      t.string :end_date, comment: "Historical end date of term use" #
      t.string :historic_flag, comment: "Flag indicating the historical status of the term (B – Both, C – Current H – Historical NA – N/A)" # C
      t.string :other_flags, comment: "Extra field for holding any flags not already represented in the term table (not used in AAT) (N/A)" # NA
      t.string :preferred, null: false, comment: "Flag indicating whether or not the term is the preferred form for its subject record (P – Preferred, V – Variant)" # V
      t.string :start_date, comment: "Historical start date of term use" #
      t.integer :subject_id, null: false, comment: "ID of the subject record associated with the term" # 300022903
      t.string :term, null: false, comment: "Term entry" # knives, gauge
      t.primary_key :term_id, null: false, comment: "Number identifying a unique term record" # 1000148239
      t.string :vernacular, null: false, comment: "Flag indicating whether or not the term is the vernacular for a certain place (V – Vernacular, O – Other, U – Undetermined)" # U
    end
  end
end
