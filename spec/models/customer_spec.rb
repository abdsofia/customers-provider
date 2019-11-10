require 'rails_helper'

RSpec.describe Customer, type: :model do
  let(:customer) do
    FactoryBot.create(:customer)
  end

  describe 'valid factory' do
    it 'is valid with valid attributes' do
      expect(customer).to be_valid
    end
  end

  describe 'validation' do
    context 'when first name' do
      it 'is blank' do
        expect(build(:customer, first_name: '')).not_to be_valid
      end

      it 'is shorter than 2 characters' do
        expect(build(:customer, first_name: 'a')).not_to be_valid
      end

      it 'is 2 characters long' do
        expect(build(:customer, first_name: 'ab')).to be_valid
      end

      it 'includes other symbols than characters' do
        expect(build(:customer, first_name: 'a5b')).not_to be_valid
        expect(build(:customer, first_name: '*a$b')).not_to be_valid
      end
    end

    context 'when last name' do
      it 'is blank' do
        expect(build(:customer, last_name: '')).not_to be_valid
      end

      it 'is shorter than 2 characters' do
        expect(build(:customer, last_name: 'a')).not_to be_valid
      end

      it 'is 2 characters long' do
        expect(build(:customer, last_name: 'ab')).to be_valid
      end

      it 'includes other symbols than characters' do
        expect(build(:customer, last_name: 'ab1')).not_to be_valid
        expect(build(:customer, last_name: 'a#b')).not_to be_valid
      end
    end

    context 'when email' do
      it 'is blank' do
        expect(build(:customer, email: '')).not_to be_valid
      end

      it { expect(customer).to_not allow_value('base@example').for(:email) }

      it { expect(customer).to_not allow_value('base.example.com').for(:email) }

      it { should validate_uniqueness_of(:email) }
    end

    context 'when date of birth' do
      it 'is blank' do
        expect(build(:customer, date_of_birth: '')).not_to be_valid
      end

      it 'is between the time range' do
        expect(customer.date_of_birth.find_age).to be_between(18, 100)
      end

      it 'is younger than 18 years old' do
        customer = build(:customer, date_of_birth: '01/01/2005')
        expect(customer.date_of_birth.find_age).not_to be_between(18, 100)
      end

      it 'is older than 100 years old' do
        customer = build(:customer, date_of_birth: '01/01/1908')
        expect(customer.date_of_birth.find_age).not_to be_between(18, 100)
      end
    end
  end
end
