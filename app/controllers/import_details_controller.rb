require 'csv'

class ImportDetailsController < ApplicationController
  before_action :get_import
  before_action :get_import_detail_by_import

  attr_accessor :import_detail

  def update
    CustomerImportWorker.perform_async(import_detail.id)
  end

  private

  def import_detail_params
    params.require(:import_detail).permit(
      :created_customers_amount,
      :rejected_customers_amount,
      :import_status, :created,
      :started_at, :completed_at,
      :import_id
    )
  end

  def get_import
    @import = Import.find(params[:import_id])
  end

  def get_import_detail_by_import
    @import_detail = @import.import_detail
  end

  def file_path
    "public#{import_detail.import.csv_file}"
  end
end
