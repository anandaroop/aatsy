class AddAncestryToSubjects < ActiveRecord::Migration[6.1]
  def change
    add_column :subjects, :ancestry, :string
    add_column :subjects, :ancestry_depth, :integer, :default => 0
    add_index :subjects, :ancestry
  end
end
