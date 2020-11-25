require 'test_helper'

class UserTest < ActiveSupport::TestCase
   
  def setup
    @user = User.new(name: "Andrei", email:"user@email.com",
                     password: "rubik1234", password_confirmation: "rubik1234")
  end

  test "user should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = 'a' * 52
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = 'a' * 256
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do 
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org 
      first.last@foo.jp alice+bob@baz.cn] 
    valid_addresses.each do |valid_address|  
      @user.email = valid_address 
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end 
  end

  test "email validation should reject invalid addresses" do 
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com example@yahoo..com] 
    invalid_addresses.each do |invalid_address|  
      @user.email = invalid_address 
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end 
  end

  test "email addresses should be unique" do
    @duplicate = @user.dup
    @user.save
    assert_not @duplicate.valid?
  end

  test "email addresses should be saved as lowercase" do
    mixed_case_email = "AnDrei@yahoo.com"
    @user.email = mixed_case_email
    @user.save
    assert_equal @user.email, mixed_case_email.downcase
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 8
    assert_not @user.valid?
  end
  
  test "password should have a minimum length" do 
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?
  end
  
  # test the application for multiple browser and login sessions with the same user
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

end
