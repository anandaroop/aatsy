class DenormalizeNameOntoSubject < ActiveRecord::Migration[6.1]
  def up
    add_column :subjects, :name, :string

    puts "Denormalizing subject names..."
    Subject.includes(:terms).where(terms: { preferred: 'P' }).each do |s|
      s.update_attribute(:name, s.terms.first.name)
    end
  end

  def down
    remove_column :subjects, :name
  end
end


