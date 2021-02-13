class Subject < ApplicationRecord
  has_ancestry cache_depth: true
  has_many :terms
  has_many :scope_notes

  FACETS = {
    activities: 300264090,
    agents: 300264089,
    associated_concepts: 300264086,
    brand_names: 300343372,
    materials: 300264091,
    objects: 300264092,
    physical_attributes: 300264087,
    styles_and_periods: 300264088,
  }

  RECORD_TYPES = {
    'C' => "Concept",
    'F' => "Facet",
    'G' => "Guide term",
    'H' => "Hierarchy name"
  }

  # CLASS METHODS

  # The root of the AAT hierarchy, identified by a special id
  def self.root
    Subject.find(300000000)
  end

  # The AAT Facets are the immediate children of the root node
  def self.facets
    root.children
  end

  def self.facet(slug)
    find(FACETS[slug])
  end

  # INSTANCE METHODS

  def to_s
    "<Subject #{ancestor_names[1..].join(" > ")}>"
  end

  def facet
    ancestors[1]
  end

  def subfacet
    ancestors[2]
  end

  def facet_from_code
    return unless facet_code.present?
    FacetCode.find(facet_code)&.subject
  end

  def record_type_name
    RECORD_TYPES[record_type]
  end

  def ancestor_names
    @ancestor_names = ancestors.map(&:name)
  end

  def ancestor_map
    @ancestor_map = ancestor_names.zip(ancestor_ids).to_h
  end

  def scope_note
    # english code, by default
    scope_notes.find_by(language_code: 70051)&.note_text
  end

  #tmp utils
  def self.sample; offset(rand(count)).limit(1).first; end
  def self.bronze; find(300010957); end
end
