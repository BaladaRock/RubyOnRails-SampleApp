require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  # Prevent code-breaking in case other tests
  # are supposed to send activation mails to same user
  def setup
    ActionMailer::Base.deliveries.clear
  end

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

  test "valid signup information with account activation" do
    get signup_path

    # Check the db by calling User.count method
    # Create a new user by submitting a post request via the rendered form
    assert_difference 'User.count', 1 do
    post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end

    # -- Test account activation--

    # Check that exactly one activation mail was sent
    assert_equal 1, ActionMailer::Base.deliveries.size

    # The 'assigns' method provides access to instance variables 
    # from different controller actions
    user = assigns(:user)
    assert_not user.activated?

    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?

    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?

    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?

    # Check the rendered template after correct
    # sign-up, login and account activation
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in? 
  end
end
