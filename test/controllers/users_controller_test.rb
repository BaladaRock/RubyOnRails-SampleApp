require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup 
    @first_user = users(:night_bot)
    @second_user = users(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@first_user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@first_user), params: { user: { name:  "hacker",
                                              email: "example@valid.com" } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@second_user)
    get edit_user_path(@first_user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@second_user)
    patch user_path(@first_user), params: { user: { name: @first_user.name,
                                                   email: @first_user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

end
