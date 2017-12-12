require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    it 'returns true if it has all valid inputs' do
      category = Category.create!(name: 'Apparel')
      product = Product.create!(name: 'shirt', price: 666, quantity: 33, category: category)
      expect(product).to be_valid
    end
    it 'fails without a name' do
      category = Category.create!(name: 'Apparel')
      product = Product.new(
              name: nil,
              price: 254,
              quantity: 2,
              category: category
              )
      expect(product).to_not be_valid
      expect(product.errors.full_messages).to include("needs name")
    end
    it 'fails without a price' do
      category = Category.create!(name: 'Apparel')
      product = Product.new(
              name: 'tee',
              price: nil,
              quantity: 2,
              category: category
              )
      expect(product).to_not be_valid
      expect(product.errors.full_messages).to include("Needs price")
    end
    it 'fails without a quantity' do
      category = Category.create!(name: 'Apparel')
      product = Product.new(
              name: 'tee',
              price: 12,
              quantity: nil,
              category: category
              )
      expect(product).to_not be_valid
      expect(product.errors.full_messages).to include("needs quantity")
    end
    it 'fails without a price' do
      category = Category.create!(name: 'Apparel')
      product = Product.new(
              name: 'tee',
              price: 12,
              quantity: 2,
              category: nil
              )
      expect(product).to_not be_valid
      expect(product.errors.full_messages).to include("needs category")
    end
  end
end