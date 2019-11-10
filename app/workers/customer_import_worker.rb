class CustomerImportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  require 'csv'

  IMPORT_STATUSES = %w[started completed].freeze

  def perform(id)
    update_import_detail_at_start(id, Time.now)

    result_data = import_customers(id)
    update_import_details_at_finish(id, result_data)
  rescue StandardError => e
    logger.warn(
      "Can not update details about the import due to: #{e.message}"
    )
  end

  private

  def batch_data_from_file(id)
    items     = []
    file_path = get_file_path(id)

    CSV.foreach(file_path, headers: true) do |row|
      items << row.to_h
    end

    items
  end

  def import_customers(id)
    items = batch_data_from_file(id)
    Customer.import items,
                    on_duplicate_key_ignore: true,
                    batch_size: ENV.fetch('BATCH_SIZE') { 500 }
  rescue StandardError => e
    logger.warn(
      "Can not import customers from the provided file due to: #{e.message}"
    )
  end

  def get_file_path(id)
    "public#{ImportDetail.find(id).import.csv_file}"
  end

  def update_import_detail_at_start(id, start_time)
    logger.info "---------------------------------------------------------\n"
    logger.info 'The import has started:'

    started = {
      import_status: IMPORT_STATUSES[0],
      started_at: start_time
    }
    UpdateImportDetailWorker.perform_at(start_time, id, started)
  end

  def update_import_details_at_finish(id, result_data)
    logger.info 'The import has finished:'
    logger.info "---------------------------------------------------------\n"

    complete_time = Time.now
    completed = {
      rejected_customers_amount: result_data.failed_instances.count,
      created_customers_amount: result_data.ids.count,
      import_status: IMPORT_STATUSES[1],
      completed_at: complete_time
    }
    UpdateImportDetailWorker.perform_at(Time.now, id, completed)
  end
end
