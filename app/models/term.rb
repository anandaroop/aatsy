class Term < ApplicationRecord
  belongs_to :subject

  scope :preferred, -> { where(preferred: 'P') }

  def name
    term
  end
end
