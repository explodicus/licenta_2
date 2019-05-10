require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: 'Example', last_name: 'User',
                     email: 'user@example.com', date_of_birth: Date.new(2000, 1, 1),
                     phone_number: '060442229', discount: 0.0,
                     preferred_language: 'Romanian', password: 'password',
                     password_confirmation: 'password')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'first name should be present' do
    @user.first_name = '     '
    assert_not @user.valid?
  end

  test 'last name should be present' do
    @user.last_name = '     '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = '     '
    assert_not @user.valid?
  end

  test 'date of birth should be present' do
    @user.date_of_birth = nil
    assert_not @user.valid?
  end

  test 'phone number should be present' do
    @user.phone_number = '      '
    assert_not @user.valid?
  end

  test 'preferred language should be present' do
    @user.preferred_language = '   '
    assert_not @user.valid?
  end

  test 'first name should not be too long' do
    @user.first_name = 'a' * 31
    assert_not @user.valid?
  end

  test 'last name should not be too long' do
    @user.last_name = 'a' * 31
    assert_not @user.valid?
  end

  test 'phone number should not be too long' do
    @user.phone_number = '0' * 10
    assert_not @user.valid?
  end

  test 'email validation should accept valid email addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@_bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?
    end
  end

  test 'email address should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'phone number validation should accept valid phone number' do
    valid_phone_number = %w[060442229 000000000 012345678]
    valid_phone_number.each do |valid_number|
      @user.phone_number = valid_number
      assert @user.valid?
    end
  end

  test 'phone number validation should reject invalid phone number' do
    invalid_phone_number = %w[0060442229 +00000000 0A1345678 .........]
    invalid_phone_number.each do |invalid_number|
      @user.phone_number = invalid_number
      assert_not @user.valid?
    end
  end

  test 'valid preferred language' do
    @user.preferred_language = 'Russian'
    assert @user.valid?
  end

  test 'invalid preferred language' do
    @user.preferred_language = 'foobar'
    assert_not @user.valid?
  end
end
