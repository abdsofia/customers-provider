class UpdateImportDetailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(id, import_detail_hash)
    ImportDetail.find(id).update(import_detail_hash)
  end
end
