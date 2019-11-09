class ImportDetail < ApplicationRecord
  belongs_to :import

  enum import_status: %i[created started completed]

  scope :details, ->(id) { where(import: id) }
end
