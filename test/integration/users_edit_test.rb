require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:night_bot)
  end

  test "edit user with invalid data" do
    # Send request to 'edit_user_path'
    get edit_user_path(@user)

    # Should receive correct template
    assert_template 'users/edit'

    # Patch request should contain [:params] with invalid values
    patch user_path(@user), params: { user: { name:           "  ",
                                       email:                 "example@invalid",
                                       password:              "foo",
                                       password_confirmation: "bar" } }

    # Should receive edit page again
    assert_template 'users/edit'

    # Check for the correct number of error messages
    assert_select "div.alert", text: "The form contains 4 errors ."
  end

  test "edit user with valid data" do
    #initialize new email and name values
    name = "Eusebiu"
    email = "example@valid.com"

    # Send request to 'edit_user_path'
    get edit_user_path(@user)

    # Should receive correct template
    assert_template 'users/edit'

    # Patch request should contain [:params] with valid values
    # and empty password fields
    patch user_path(@user), params: { user: { name:           name,
                                       email:                 email,
                                       password:              "",
                                       password_confirmation: "" } }

    # Check for flash message presence
    assert_not flash.empty?

    # Should be redirected to user profile page
    assert_redirected_to @user

    # Reload user from db and check its attributes
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

end
