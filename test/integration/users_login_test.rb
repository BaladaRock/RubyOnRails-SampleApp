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
    
    # Check for error flash
    assert_not flash.empty?
    
    # Redirrect to HomePage
    get root_path
    
    # Verify that the error flash message has disappeared
    assert flash.empty?
  end

  test "login with valid email/invalid password" do
    # Send a request to correct path
    get login_path

    # Post a valid session hash(using @user that was created by the help 
    # of users.yml fixtures class)
    post login_path, params: { session: { email: 'example@railstutorial.org',
                                          password: 'password' } }

    # Check the redirect target                                 
    assert_redirected_to @user

    #Visit the target page
    follow_redirect!

    #Check for the wanted layout
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
  
end
