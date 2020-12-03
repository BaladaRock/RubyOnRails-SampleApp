require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup database state" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" } }
    end
    
  end

  test "invalid signup view state" do
    get signup_path
    post users_path, params: { user: { name: "Andrei",
                                       email: "user@yahoo.com",
                                       password: "bar",
                                       password_confirmation: "bar" } }
    assert_template 'users/new'
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
    assert_select ".form-control", count: 4
  end

  test "valid signup information" do
    get signup_path

    #Check the db by calling User.count method
    assert_difference 'User.count', 1 do
    post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    #assert_template 'users/show'
    #assert_not flash.empty?
    #assert is_logged_in? 
  end
  
end
