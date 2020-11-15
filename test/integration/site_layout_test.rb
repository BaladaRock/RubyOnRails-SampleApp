require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2 
    assert_select "a[href=?]", '/', count: 2 
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  test "full_title contact" do
    get contact_path
    assert_select "title", full_title("Contact")
  end

  test "full_title signup" do
    get signup_path
    assert_select "title", full_title("Sign up")
  end

end
