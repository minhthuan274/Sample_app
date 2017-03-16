require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user       = users(:thuan)
    @other_user = users(:binh)
  end

  test "should redirect update when not logged in " do 
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do 
    assert_no_difference "User.count" do 
      delete user_path @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do 
    log_in_as @other_user
    assert_no_difference "User.count" do 
      delete user_path @user
    end
    assert_redirected_to root_url
  end

  test "should redirect following when not logged in " do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user) 
    assert_redirected_to login_url
  end
end
