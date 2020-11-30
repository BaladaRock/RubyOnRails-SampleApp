require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:night_bot)
  end

  test "index including pagination" do
    # Login user
    log_in_as @user

    # Send request for users list page
    get users_path

    # Should receive 'all users' template
    assert_template 'users/index'

    # Check the elements of the pagination
    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end  

    # Assure that both of the paginations are displayed
    assert_select 'div.pagination', count: 2

  end
end
