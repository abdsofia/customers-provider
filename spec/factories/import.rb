FactoryBot.define do
  factory :import do
    title       { "Title" }
    csv_file    { Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, 'spec/fixtures/public/uploads/import/test_file.csv'))) }
  end
end
