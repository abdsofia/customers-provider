require 'csv'

class ImportDetailsController < ApplicationController
  before_action :get_import
  before_action :get_import_detail

  attr_accessor :import_detail

  def update
    batch = Sidekiq::Batch.new
    batch.on(:success, CustomerImportWorker, 'id' => import_detail.id)
    batch.jobs do
      CustomerImportWorker.perform_async(import_detail.id)
    end
  end

  private

  def import_detail_params
    params.require(:import_detail).permit(:created_customers_amount, :rejected_customers_amount, :import_status, :created, :started_at, :completed_at, :import_id)
  end

  def get_import
    @import = Import.find(params[:import_id])
  end

  def get_import_detail
    @import_detail = @import.import_detail
  end

  def file_path
    "public#{import_detail.import.csv_file}"
  end
end
