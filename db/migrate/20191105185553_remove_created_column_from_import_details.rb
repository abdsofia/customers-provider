class RemoveCreatedColumnFromImportDetails < ActiveRecord::Migration[6.0]
  def change
    remove_column :import_details, :created, :timestamp
  end
end
