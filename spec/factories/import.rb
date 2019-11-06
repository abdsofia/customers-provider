FactoryBot.define do
  factory :import do
    title       { "Title" }
    csv_file    { "uploads/import/test_file.csv" }
  end
end
