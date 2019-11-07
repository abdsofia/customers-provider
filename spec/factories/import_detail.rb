FactoryBot.define do
  factory :import_detail do
    created_customers_amount  { 0 }
    rejected_customers_amount { 0 }
    import_status { 0 }
    started_at { Time.now }
    completed_at { Time.now + 1.second }
    import_id { 1 }
  end
end
