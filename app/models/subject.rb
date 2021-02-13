class Subject < ApplicationRecord
  include Elasticsearch::Model

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

  # Can follow the query search syntax:
  # https://www.elastic.co/guide/en/elasticsearch/reference/5.6/query-dsl-query-string-query.html#query-string-syntax
  #
  # For example:
  #
  # Subject.console_search('"bronze age" name:"bronze age"^2 NOT record_type:C')
  #
  # To
  # - search for a phrase everywhere,
  # - but boost results with the phrase in the preferred term name
  # - filter out results which are Concepts
  #
  def self.console_search(q)
    Subject.search(q).records.order(:ancestry_depth).map do |s|
      "\n%s %s %s\n%s\n%s\n%s" % [
        s.name.bold,
        s.ancestors[1] && s.ancestors[1].name.split[0].green,
        s.record_type_name.light_blue,
        (s.ancestor_names[2..] || []).join(" ‣ ").cyan,
        s.scope_note,
        s.terms.map(&:term).join("; ").light_black
      ]
    end
  end
end
