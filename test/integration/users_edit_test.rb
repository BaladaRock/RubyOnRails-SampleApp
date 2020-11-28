require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:night_bot)
  end

  test "edit user with invalid information" do
    # Send request to 'edit_user_path'
    get edit_user_path(@user)

    # Should receive correct template
    assert_template 'users/edit'

    # Patch request should contain [:params] with invalid values
    patch user_path(@user), params: { user: { name:                 "  ",
                                       email:                "example@invalid",
                                       password:             "foo",
                                       password_confirmation: "bar" } }

    # Should receive edit page again
    assert_template 'users/edit'

    # Check for the correct number of error messages
    assert_select "div.alert", text: "The form contains 4 errors ."
  end

end
