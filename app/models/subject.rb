class Subject < ApplicationRecord
  belongs_to :parent, class_name: 'Subject', foreign_key: "parent_key"
  has_many :children, class_name: 'Subject', foreign_key: "parent_key"
  has_many :terms
end
