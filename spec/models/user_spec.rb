require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'user is valid if it has all valid inputs' do
      user = User.new(
        first_name: 'bob',
        last_name: 'hill',
        email: 'email@email.com',
        password: '1234567',
        password_confirmation: '1234567')
      expect(user).to be_valid
    end
    it 'user is invalid if it doesnt have a password' do
      user = User.new(
        first_name: 'bob',
        last_name: 'hill',
        email: 'email@email.com',
        password: nil,
        password_confirmation: '1234567')
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Password can't be blank")
    end
    it 'user is invalid if it doesnt have a password confirmation' do
      user = User.new(
        first_name: 'bob',
        last_name: 'hill',
        email: 'email@email.com',
        password: '1234567',
        password_confirmation: nil)
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Password confirmation can't be blank")
    end
    it 'user is invalid if password and confirmation dont match' do
      user = User.new(
        first_name: 'bob',
        last_name: 'hill',
        email: 'email@email.com',
        password: '1234567',
        password_confirmation: '1234567')
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end
    it 'user is invalid if email already taken' do
      user1 = User.create!(
        first_name: 'bob1',
        last_name: 'hill1',
        email: 'email@email.com',
        password: '1234567',
        password_confirmation: '1234567')
      user2 = User.new(
        first_name: 'bob2',
        last_name: 'hill2',
        email: 'email@email.com',
        password: '1234567',
        password_confirmation: '1234567')
      expect(user2).to_not be_valid
      expect(user2.errors.full_messages).to include("Email has already been taken")
    end
    it 'user is invalid if email already taken even if diff case' do
      user1 = User.create!(
        first_name: 'bob1',
        last_name: 'hill1',
        email: 'email@email.com',
        password: '1234567',
        password_confirmation: '1234567')
      user2 = User.new(
        first_name: 'bob',
        last_name: 'hill',
        email: 'Email@email.com',
        password: '1234567',
        password_confirmation: '1234567')
      expect(user2).to_not be_valid
      expect(user2.errors.full_messages).to include("Email has already been taken")
    end
    it 'user is invalid if it doesnt have a first name' do
      user = User.new(
        first_name: nil,
        last_name: 'hill',
        email: 'email@email.com',
        password: '1234567',
        password_confirmation: '1234567')
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("First name can't be blank")
    end
    it 'user is invalid if it doesnt have a last name' do
      user = User.new(
        first_name: 'bob',
        last_name: nil,
        email: 'email@email.com',
        password: '1234567',
        password_confirmation: '1234567')
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Last name can't be blank")
    end
    it 'user is invalid if it doesnt have an email' do
      user = User.new(
        first_name: 'bob',
        last_name: 'hill',
        email: nil,
        password: '1234567',
        password_confirmation: '1234567')
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Email can't be blank")
    end
    it 'user is invalid password is too short' do
      user = User.new(
        first_name: 'bob',
        last_name: 'hill',
        email: 'email@email.com',
        password: '123',
        password_confirmation: '123')
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Password is too short (minimum is 8 characters)")
    end
  end

  describe '.authenticate_with_credentials' do
    it 'should return a valid user if login is valid' do
      user = User.create(
        first_name: 'bob',
        last_name: 'hill',
        email: 'email@email.com',
        password: '1234567',
        password_confirmation: '1234567')
      auth_user = User.authenticate_with_credentials('email@email.com', '1234567')
      expect(auth_user).to eq(user)
    end
    it 'should not authenticate if login is not valid' do
      user = User.create(
        first_name: 'bob',
        last_name: 'hill',
        email: 'email@email.com',
        password: '1234567',
        password_confirmation: '1234567')
      auth_user = User.authenticate_with_credentials('email@email.com', '1234567')
      expect(auth_user).to_not eq(user)
    end
    it 'should return nil if password is not valid' do
      user = User.create(
        first_name: 'bob',
        last_name: 'hill',
        email: 'email@email.com',
        password: '1234567',
        password_confirmation: '1234567')
      auth_user = User.authenticate_with_credentials('email@email.com', '34567')
      expect(auth_user).to be_nil
    end
    it 'should return nil if email is not valid' do
      user = User.create(
        first_name: 'bob',
        last_name: 'hill',
        email: 'email@email.com',
        password: '1234567',
        password_confirmation: '1234567')
      auth_user = User.authenticate_with_credentials('emails.com', '1234567')
      expect(auth_user).to be_nil
    end
    it 'should return a valid user if login is valid even if the email has spaces' do
      user = User.create(
        first_name: 'bob',
        last_name: 'hill',
        email: 'email@email.com',
        password: '1234567',
        password_confirmation: '1234567')
      auth_user = User.authenticate_with_credentials('email@email.com   ', '1234567')
      expect(auth_user).to eq(user)
    end
    it 'should return a valid user if login is valid even if the email has spaces' do
      user = User.create(
        first_name: 'bob',
        last_name: 'hill',
        email: 'email@email.com',
        password: '1234567',
        password_confirmation: '1234567')
      auth_user = User.authenticate_with_credentials('   email@email.com', '1234567')
      expect(auth_user).to eq(user)
    end
    it 'should return a valid user if login is valid even if the email has wrong case' do
      user = User.create(
        first_name: 'bob',
        last_name: 'hill',
        email: 'email@email.com',
        password: '1234567',
        password_confirmation: '1234567')
      auth_user = User.authenticate_with_credentials('email@EMAIL.com', '1234567')
      expect(auth_user).to eq(user)
    end
    it 'should return a valid user if login is valid even if the email has wrong case' do
      user = User.create(
        first_name: 'bob',
        last_name: 'hill',
        email: 'EmaIl@email.com',
        password: '1234567',
        password_confirmation: '1234567')
      auth_user = User.authenticate_with_credentials('email@email.com', '1234567')
      expect(auth_user).to eq(user)
    end
  end
end