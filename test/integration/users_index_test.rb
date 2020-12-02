require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:night_bot)
    @non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    # Login user
    log_in_as @admin

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
    
    # Get the first page of users and check that 'delete' option
    # is available for every non-admin ones
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    
    # Check that deleting one non-admin user has worked
    assert_difference 'User.count', -1 do
    delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path

    # Non-admin users should not be able to delete other users
    assert_select 'a', text: 'delete', count: 0
  end


end
