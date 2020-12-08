require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
 
  def setup
    @user = users(:night_bot)
  end

  test "micropost interface" do
    # Login on site
    log_in_as(@user)
    get root_path

    # Check for micropost pagination
    assert_select 'div.pagination'

    # Try to make an invalid micropost submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "  " } }
    end

    # Check for error message and pagination links
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2' 

    # Make a valid submission
    content = "Lorem ipsum est"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end

    # 'Home' page should be rendered again and the newly
    # created micropost should appear inside HTML page
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

    # Delete a post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # Visit another user's page
    get user_path(users(:archer))

    # Check that no 'delete' link is present
    assert_select 'a', text: 'delete', count: 0
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # User with zero microposts
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end

end
