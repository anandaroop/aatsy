class Subject < ApplicationRecord
  belongs_to :parent, class_name: 'Subject', foreign_key: "parent_key"
  has_many :children, class_name: 'Subject', foreign_key: "parent_key"
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
end
