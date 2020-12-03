require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest
  def setup
    @activated = users(:night_bot)
    @inactive = users(:inactive)
  end

  test "inactive user should not have access to user show page" do
    get user_path(@inactive)
    assert_redirected_to root_url
  end

  test "activateduser should have access to user show page" do
    get user_path(@activated)
    assert_template 'users/show'
    assert_response :success
  end
end
