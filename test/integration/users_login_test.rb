require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:night_bot)
  end

  test "login with invalid information" do
    # Send a request to correct path
    get login_path
    
    # Verify form rendering
    assert_template 'sessions/new'
    
    # Post an invalid session params hash
    post login_path, params: { session: { email: "   ", password: ""} }
    
    # Check that form has got re-rendered
    assert_template 'sessions/new'
    
    # Check for presence of the error flash
    assert_not flash.empty?
    
    # Redirrect to HomePage
    get root_path
    
    # Verify that the error flash message has disappeared
    assert flash.empty?
  end

  test "login with valid email/invalid password" do
    # Send a request for login_page
    get login_path

    # Check that the received template is the login_page content
    assert_template 'sessions/new'

    # Fill in the form with correct email and incorrect password
    post login_path, params: { session: { email:    @user.email,
                                          password: "invalid" } }
      
    # Certify that no user logged in                                      
    assert_not is_logged_in?

    # Recheck for login page template
    assert_template 'sessions/new'

    # Flash warning should be present
    assert_not flash.empty?

    # Flash warning should dissapear after sending another request
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    # Send a request for login_page
    get login_path

    # Fill in the form with correct email and password
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    
    # User should be logged in  and browser should automatically
    # be redirected to its profile page                                   
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!

    # Check for the wanted layout elements
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    # After that, log out
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url

    # Simulate a user clicking logout in a second window.
    delete logout_path
    
    # Redirect to home_page
    follow_redirect!

    # Layout elements should get back to the normal, no-login state
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  # Tests the 'remember me' checkbox
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    # Log in to set the cookie.
    log_in_as(@user, remember_me: '1')
    # Log in again and verify that the cookie is deleted.
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
