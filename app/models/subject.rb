class Subject < ApplicationRecord
  has_ancestry cache_depth: true
  has_many :terms

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

  def name
    preferred_term.name
  end

  def all_names
    terms.map(&:name)
  end

  def preferred_term
    terms.find_by(preferred: 'P')
  end

  def facet
    ancestors[1]
  end

  def subfacet
    ancestors[2]
  end

  # unlike default #ancestors this eager loads associated Term
  def ancestor_nodes
    @ancestor_nodes ||= Subject.includes(:terms).where(terms: { preferred: 'P' }).find(ancestor_ids)
  end

  # makes use of eager-loaded Terms
  def ancestor_names
    @ancestor_names = ancestor_nodes.map{ |s| s.terms.first.name }
  end

  # efficient hash of ancestor ids => names
  def ancestor_map
    @ancestor_map = ancestor_names.zip(ancestor_ids).to_h
  end

  #tmp utils
  def self.sample; offset(rand(count)).limit(1).first; end
  def self.bronze; find(300010957); end
end
