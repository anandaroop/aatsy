class CreateFacetCodes < ActiveRecord::Migration[6.1]
  def up
    create_table :facet_codes, id: false, comment: "Derived table of AAT facet codes" do |t|
      t.string :code, primary_key: true, comment: "Short code for an AAT facet or subfacet"
      t.string :name, null: false, comment: "Name of an AAT facet or subfacet"
      t.integer :subject_id, comment: "Root Subject node of the facet or subfacet"
    end

    ActiveRecord::Base.connection.execute <<~SQL
      insert into facet_codes(code, name) (WITH roots AS (
        SELECT
          facet_code,
          min(ancestry_depth)
        FROM
          subjects
        GROUP BY
          facet_code
      )
      SELECT
        r.facet_code as code,
        s.name
      FROM
        roots r
        JOIN subjects s ON s.facet_code = r.facet_code
        AND s.ancestry_depth = r.min
        AND r.facet_code not like 'X%' and r.facet_code <> ''
      ORDER BY
        r.facet_code)
    SQL

    # add root ids
    FacetCode.all.each do |fc|
      root_subject = Subject.where(facet_code: fc.code).order(ancestry_depth: :asc).first
      fc.update!(subject_id: root_subject.id)
    end
  end

  def down
    drop_table :facet_codes
  end
end
