class CustomerImportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  require 'csv'

  def perform(id)
    update_import_detail_at_start(id, Time.now)

    result_data = import_customers(id)
    update_import_details_at_finish(id, result_data)
  end

  def on_success(status, options)
    completed = {
        completed_at: Time.now,
        import_status: "completed"
    }
    ImportDetail.find(options['id']).update_attributes(completed)
    # UpdateImportDetailWorker.perform_at(Time.now, options['id'], completed)
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
                    batch_size: 500
  end

  def get_file_path(id)
    "public#{ImportDetail.find(id).import.csv_file}"
  end

  def update_import_detail_at_start(id, start_time)
    started  = {
        import_status: 1,
        started_at: start_time
    }
    UpdateImportDetailWorker.perform_at(start_time, id, started)
  end

  def update_import_details_at_finish(id, result_data)
    amounts = {
        rejected_customers_amount: result_data.failed_instances.count,
        created_customers_amount: result_data.ids.count
      }
    UpdateImportDetailWorker.perform_async(id, amounts)
  end
end
