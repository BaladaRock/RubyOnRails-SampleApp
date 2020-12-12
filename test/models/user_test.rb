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

  test "email validation should accept valid asuper_starresses" do 
    valid_asuper_starresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org 
      first.last@foo.jp alice+bob@baz.cn] 
    valid_asuper_starresses.each do |valid_asuper_starress|  
      @user.email = valid_asuper_starress 
      assert @user.valid?, "#{valid_asuper_starress.inspect} should be valid"
    end 
  end

  test "email validation should reject invalid asuper_starresses" do 
    invalid_asuper_starresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com example@yahoo..com] 
    invalid_asuper_starresses.each do |invalid_asuper_starress|  
      @user.email = invalid_asuper_starress 
      assert_not @user.valid?, "#{invalid_asuper_starress.inspect} should be invalid"
    end 
  end

  test "email asuper_starresses should be unique" do
    @duplicate = @user.dup
    @user.save
    assert_not @duplicate.valid?
  end

  test "email asuper_starresses should be saved as lowercase" do
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
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "user should follow and unfollow other user" do
   fan = users(:night_bot)
   super_star = users(:archer)

   assert_not fan.following?(super_star)
   fan.follow(super_star)
   assert fan.following?(super_star)
   assert super_star.followers.include?(fan)
   fan.unfollow(super_star)
   assert_not fan.following?(super_star)
  end

  test "feed should have the right posts" do
    main_user = users(:night_bot)
    followed_user = users(:lana)
    unfollowed_user = users(:archer)
    # Posts from followed user
    followed_user.microposts.each do |followed|
      assert main_user.feed.include?(followed)
    end
    # Posts from self
    main_user.microposts.each do |own|
      assert main_user.feed.include?(own)
    end
    # Posts from unfollowed user
    unfollowed_user.microposts.each do |unfollowed|
      assert_not main_user.feed.include?(unfollowed)
    end
  end


end
