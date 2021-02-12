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

  #tmp utils
  def self.sample; offset(rand(count)).limit(1).first; end
  def self.bronze; find(300010957); end
end
