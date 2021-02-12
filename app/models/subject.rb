class Subject < ApplicationRecord
  has_ancestry cache_depth: true
  has_many :terms

  def name
    preferred_term.name
  end

  def all_names
    terms.map(&:name)
  end

  def preferred_term
    terms.find_by(preferred: 'P')
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
