require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

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
  
end
