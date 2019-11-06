class ImportDetail < ApplicationRecord
  belongs_to :import

  enum import_status: [:created, :started, :completed]

  scope :details, -> (id) { where(import: id) }
end
