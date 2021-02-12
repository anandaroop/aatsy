class PrepareSubjectsForAncestry < ActiveRecord::Migration[6.1]
  def up
    change_column_null :subjects, :parent_key, true
    rename_column :subjects, :parent_key, :parent_id
    Subject.find(300000000).update_attribute(:parent_id, nil)
  end

  def down
    Subject.find(300000000).update_attribute(:parent_id, 300000000)
    rename_column :subjects, :parent_id, :parent_key
    change_column_null :subjects, :parent_key, false
  end
end
