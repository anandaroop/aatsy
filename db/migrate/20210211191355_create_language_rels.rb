class CreateLanguageRels < ActiveRecord::Migration[6.1]
  def change
    create_table :language_rels, id: false, comment: "The language relationship table contains links between terms and a controlled set of languages. In subject records, only one term can be preferred for each language in a particular subject." do |t|
      t.string :language_code, null: false, comment: "Language code in language relationship"
      t.string :preferred, null: false, comment: "Flag indicating whether or not the term is preferred for the language in a particular subject record"
      t.integer :subject_id, null: false, comment: "Subject ID number in language relationship"
      t.integer :term_id, null: false, comment: "Term ID number in language relationship"
      t.string :qualifier, comment: "Label to disambiguate homophones in AAT (D – Descriptor AD – Alternate Descriptor, UF – Used For Term)"
      t.string :term_type, null: false, comment: "Term type"
      t.string :part_of_speech, null: false, comment: "Flag to indicate term part of speech for a particular language (U - Undetermined, N - Noun, PN - Plural Noun SN - Singular Noun G - Singular and Plural Gerund, PP - Past Participle VN - Verbal Noun AJ - Adjectival, NA - N/A)"
      t.string :lang_stat, null: false, comment: "Language status flag used to indicate loan terms (U - Undetermined NA - N/A, L - Loan Term )"
    end
  end
end
