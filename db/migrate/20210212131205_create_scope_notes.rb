class CreateScopeNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :scope_notes, id: false, comment: "Descriptive notes linked to a subject record associated with a particular language" do |t|
      t.primary_key :scope_note_id, null: false, comment: "Unique ID for a scope note record"
      t.integer :subject_id, null: false, comment: "ID of subject record related to scope note"
      t.string :language_code, null: false, comment: "Numeric code indicating the language of the descriptive note"
      t.text :note_text, null: false, comment: "The descriptive note text"
    end
  end
end
