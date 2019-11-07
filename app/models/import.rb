class Import < ApplicationRecord
  has_one :import_detail, dependent: :destroy

  validates :title, presence: true
  validates :csv_file, presence: true

  mount_uploader :csv_file, FileCsvUploader
end
