require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'user is valid if it has all valid inputs' do
      user = User.new(first_name: 'shirt',
        last_name: 'tony',
        email: 'me@me',
        password: 'bobbobbob',
        password_confirmation: 'bobbobbob')
      expect(user).to be_valid
    end
    it 'user is invalid if it doesnt have a password' do
      user = User.new(first_name: 'shirt',
        last_name: 'tony',
        email: 'me@me',
        password: nil,
        password_confirmation: 'bobbobbob')
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Password can't be blank")
    end
    it 'user is invalid if it doesnt have a password confirmation' do
      user = User.new(first_name: 'shirt',
        last_name: 'tony',
        email: 'me@me',
        password: 'bobbobbob',
        password_confirmation: nil)
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Password confirmation can't be blank")
    end
    it 'user is invalid if password and confirmation dont match' do
      user = User.new(first_name: 'shirt',
        last_name: 'tony',
        email: 'me@me',
        password: 'bobbobbob',
        password_confirmation: 'babbabbab')
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end
    it 'user is invalid if email already taken' do
      user1 = User.create!(
        first_name: 'shirt1',
        last_name: 'tony1',
        email: 'me@me',
        password: 'bobbobbob',
        password_confirmation: 'bobbobbob')
      user2 = User.new(
        first_name: 'shirt',
        last_name: 'tony',
        email: 'me@me',
        password: 'bobbobbob',
        password_confirmation: 'bobbobbob')
      expect(user2).to_not be_valid
      expect(user2.errors.full_messages).to include("Email has already been taken")
    end
    it 'user is invalid if email already taken even if diff case' do
      user1 = User.create!(
        first_name: 'shirt1',
        last_name: 'tony1',
        email: 'me@me',
        password: 'bobbobbob',
        password_confirmation: 'bobbobbob')
      user2 = User.new(
        first_name: 'shirt',
        last_name: 'tony',
        email: 'ME@me',
        password: 'bobbobbob',
        password_confirmation: 'bobbobbob')
      expect(user2).to_not be_valid
      expect(user2.errors.full_messages).to include("Email has already been taken")
    end
    it 'user is invalid if it doesnt have a first name' do
      user = User.new(
        first_name: nil,
        last_name: 'tony',
        email: 'me@me',
        password: 'bobbobbob',
        password_confirmation: 'bobbobbob')
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("First name can't be blank")
    end
    it 'user is invalid if it doesnt have a last name' do
      user = User.new(
        first_name: 'shirt',
        last_name: nil,
        email: 'me@me',
        password: 'bobbobbob',
        password_confirmation: 'bobbobbob')
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Last name can't be blank")
    end
    it 'user is invalid if it doesnt have an email' do
      user = User.new(
        first_name: 'shirt',
        last_name: 'tony',
        email: nil,
        password: 'bobbobbob',
        password_confirmation: 'bobbobbob')
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Email can't be blank")
    end
    it 'user is invalid password is too short' do
      user = User.new(
        first_name: 'shirt',
        last_name: 'tony',
        email: 'me@me',
        password: 'bobbob',
        password_confirmation: 'bobbob')
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Password is too short (minimum is 8 characters)")
    end
  end

  describe '.authenticate_with_credentials' do
    it 'should return a valid user if login is valid' do
      user = User.create(
        first_name: 'shirt',
        last_name: 'tony',
        email: 'me@me',
        password: 'bobbobbob',
        password_confirmation: 'bobbobbob')
      auth_user = User.authenticate_with_credentials('me@me', 'bobbobbob')
      expect(auth_user).to eq(user)
    end
    it 'should not authenticate if login is not valid' do
      user = User.create(
        first_name: 'shirt',
        last_name: 'tony',
        email: 'me@me',
        password: 'bobbobbob',
        password_confirmation: 'bobbobbob')
      auth_user = User.authenticate_with_credentials('me@me', 'babbobbob')
      expect(auth_user).to_not eq(user)
    end
    it 'should return nil if password is not valid' do
      user = User.create(
        first_name: 'shirt',
        last_name: 'tony',
        email: 'me@me',
        password: 'bobbobbob',
        password_confirmation: 'bobbobbob')
      auth_user = User.authenticate_with_credentials('me@me', 'babbobbob')
      expect(auth_user).to be_nil
    end
    it 'should return nil if email is not valid' do
      user = User.create(
        first_name: 'shirt',
        last_name: 'tony',
        email: 'me@me',
        password: 'bobbobbob',
        password_confirmation: 'bobbobbob')
      auth_user = User.authenticate_with_credentials('memmm@me', 'bobbobbob')
      expect(auth_user).to be_nil
    end
    it 'should return a valid user if login is valid even if the email has spaces' do
      user = User.create(
        first_name: 'shirt',
        last_name: 'tony',
        email: 'me@me',
        password: 'bobbobbob',
        password_confirmation: 'bobbobbob')
      auth_user = User.authenticate_with_credentials('me@me   ', 'bobbobbob')
      expect(auth_user).to eq(user)
    end
    it 'should return a valid user if login is valid even if the email has spaces' do
      user = User.create(
        first_name: 'shirt',
        last_name: 'tony',
        email: 'me@me',
        password: 'bobbobbob',
        password_confirmation: 'bobbobbob')
      auth_user = User.authenticate_with_credentials('   me@me', 'bobbobbob')
      expect(auth_user).to eq(user)
    end
    it 'should return a valid user if login is valid even if the email has wrong case' do
      user = User.create(
        first_name: 'shirt',
        last_name: 'tony',
        email: 'me@me',
        password: 'bobbobbob',
        password_confirmation: 'bobbobbob')
      auth_user = User.authenticate_with_credentials('me@ME', 'bobbobbob')
      expect(auth_user).to eq(user)
    end
    it 'should return a valid user if login is valid even if the email has wrong case' do
      user = User.create(
        first_name: 'shirt',
        last_name: 'tony',
        email: 'me@ME',
        password: 'bobbobbob',
        password_confirmation: 'bobbobbob')
      auth_user = User.authenticate_with_credentials('me@me', 'bobbobbob')
      expect(auth_user).to eq(user)
    end
  end
end