require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:night_bot)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test "content should be maximum 140 characters long" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "microposts order last one should be first element" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
