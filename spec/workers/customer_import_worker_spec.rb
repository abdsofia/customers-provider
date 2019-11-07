require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe CustomerImportWorker, type: :worker do

  describe "Customer Import Worker" do
    let! (:import) { FactoryBot.create(:import) }
    let! (:import_detail) { FactoryBot.create(:import_detail, import_id: import.id) }

    describe "Worker" do
      Sidekiq::Testing.fake! do
        it "should respond to #perform" do
          expect(CustomerImportWorker.new).to respond_to(:perform)
        end

        it 'enqueue a job' do
          expect {
            CustomerImportWorker.perform_async(import_detail.id)
          }.to change(CustomerImportWorker.jobs, :size).by 1
        end
      end
    end

    describe "Import Detail" do
      let(:now) { Time.now }
      before do
        Sidekiq::Worker.clear_all
        Timecop.freeze(now) do
          Sidekiq::Testing.inline! do
            CustomerImportWorker.perform_async(import_detail.id)
          end
        end
      end

      it "should change import_detail status to started" do
        import_detail.reload
        expect(import_detail.import_status).to eq("started")
      end
    end
  end
end