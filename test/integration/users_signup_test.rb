require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup template" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
  end

  test "invalid signup classes" do
    get signup_path
    post users_path, params: { user: { name: "Andrei",
                                       email: "user@yahoo.com",
                                       password: "bar",
                                       password_confirmation: "bar" } }
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
    assert_select ".form-control", count: 4
  end
  
end
