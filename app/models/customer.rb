class Customer < ApplicationRecord
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: true, email: true
  validates :date_of_birth, presence: true
  validates_format_of :first_name, :last_name, with: /\A[a-z]+\z/i
  validate :validate_age

  private

  def validate_age
    if date_of_birth && !(18..100).include?(date_of_birth.find_age)
      errors.add(:date_of_birth, "a customer can not be younger than 18 or older than 100")
    end
  end
end
