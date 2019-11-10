require 'rails_helper'

RSpec.describe ImportsController, type: :controller do
  let!(:import) do
    FactoryBot.create(:import)
  end

  let(:valid_attributes) do
    {
      title: 'Title',
      csv_file: fixture_file_upload('/public/uploads/import/test_file.csv')
    }
  end

  let(:blank_title_import) do
    {
      title: '',
      csv_file: fixture_file_upload('/public/uploads/import/test_file.csv')
    }
  end

  let(:blank_csv_file_import) do
    {
      title: 'Title',
      csv_file: ''
    }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      puts :import.inspect
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: {
        id: import.id
      }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: {
        id: import.to_param
      }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Import' do
        expect do
          post :create, params: {
            import: valid_attributes
          }
        end.to change(Import, :count).by(1)
      end

      it 'creates an associated ImportDetail' do
        expect do
          post :create, params: {
            import: valid_attributes
          }
        end.to change(ImportDetail, :count).by(1)
      end

      it 'redirects to the created import' do
        post :create, params: {
          import: valid_attributes
        }
        expect(response).to redirect_to(Import.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {
          import: blank_csv_file_import
        }
        expect(response).to be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          title: 'New Title',
          csv_file: fixture_file_upload('/public/uploads/import/new_test_file.csv')
        }
      end

      it 'updates the title of the requested import' do
        put :update, params: {
          id: import.to_param, import: new_attributes
        }
        import.reload
        expect(import.title).to eq(new_attributes[:title])
      end

      it 'updates the csv_file path of the requested import' do
        put :update, params: {
          id: import.to_param, import: new_attributes
        }
        import.reload
        expect(import.csv_file.identifier).to eq(new_attributes[:csv_file].original_filename)
      end

      it 'redirects to the import' do
        put :update, params: {
          id: import.to_param, import: new_attributes
        }
        expect(response).to redirect_to(import)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {
          id: import.to_param, import: blank_csv_file_import
        }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:import_detail) do
      FactoryBot.create(:import_detail, import_id: import.id)
    end

    it 'destroys the requested import' do
      expect do
        delete :destroy, params: {
          id: import.to_param
        }
      end.to change(Import, :count).by(-1)
    end

    it 'destroys the associated ImportDetail' do
      expect do
        delete :destroy, params: {
          id: import.to_param
        }
      end.to change(ImportDetail, :count).by(-1)
    end

    it 'redirects to the imports list' do
      delete :destroy, params: {
        id: import.to_param
      }
      expect(response).to redirect_to(imports_url)
    end
  end
end
