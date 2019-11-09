FactoryBot.define do
  factory :customer do
    first_name       { 'John' }
    last_name        { 'Doe' }
    date_of_birth    { '01/01/1999' }
    sequence(:email) { |step| "customer#{step}@example.com" }
  end
end
