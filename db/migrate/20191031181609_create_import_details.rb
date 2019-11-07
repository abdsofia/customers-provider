class CreateImportDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :import_details do |t|
      t.integer :created_customers_amount
      t.integer :rejected_customers_amount
      t.integer :import_status
      t.timestamp :created
      t.timestamp :started_at
      t.timestamp :completed_at
      t.references :import, null: false, foreign_key: true

      t.timestamps
    end
  end
end
