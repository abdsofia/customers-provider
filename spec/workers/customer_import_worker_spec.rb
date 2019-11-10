require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe CustomerImportWorker, type: :worker do
  describe 'Customer Import Worker' do
    let! (:import) do
      FactoryBot.create(:import)
    end
    let! (:import_detail) do
      FactoryBot.create(:import_detail, import_id: import.id)
    end

    describe 'Worker itself' do
      Sidekiq::Testing.fake! do
        it 'should respond to #perform' do
          expect(CustomerImportWorker.new).to respond_to(:perform)
        end

        it 'enqueue a job' do
          expect do
            CustomerImportWorker.perform_async(import_detail.id)
          end.to change(CustomerImportWorker.jobs, :size).by 1
        end
      end
    end

    describe 'for Customer' do
      let(:now) { Time.now }
      before do
        Sidekiq::Worker.clear_all
        Timecop.freeze(now) do
          Sidekiq::Testing.inline! do
            CustomerImportWorker.perform_async(import_detail.id)
          end
        end
      end

      it 'should include one item' do
        expect(Customer.count).to eq(1)
      end
    end

    describe 'for Import Detail' do
      let(:now) { Time.now }
      before do
        Sidekiq::Worker.clear_all
        Timecop.freeze(now) do
          Sidekiq::Testing.inline! do
            CustomerImportWorker.perform_async(import_detail.id)
          end
        end
      end

      it 'should change import_detail status to started' do
        import_detail.reload
        expect(import_detail.import_status).to eq('completed')
      end

      it 'should change import_detail status to started' do
        import_detail.reload
        expect(import_detail.created_customers_amount).to eq(1)
      end

      it 'should change import_detail status to started' do
        import_detail.reload
        expect(import_detail.rejected_customers_amount).to eq(13)
      end
    end
  end
end
