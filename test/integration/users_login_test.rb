require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:thuan)
  end

  test "login with invalid information" do 
    #visit the login page and verify that new session form render properly
    get login_path
    assert_template 'sessions/new'
    # Post to the session path with an invalid params 
    # and verify that the new session form get re-render and the flash message appears
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new' 
    assert_not flash.empty?

    # Visit another page like Home page
    # Verify the flash doesn't appear on that page 
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do 
    # Visit the login path 
    get login_path 
    # Post valid information user to login path 
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show' 
    # Verify the login path disappears
    assert_select "a[href=?]", login_path, count: 0
    # Verify the logout path appears
    assert_select "a[href=?]", logout_path 
    # Verify the profile link appears
    assert_select "a[href=?]", user_path(@user)

    # Log out 
    delete logout_path 
    assert_not is_logged_in?
    assert_redirected_to root_url

    #Simulate a user clicking logout in a second window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "authenticatd? should return false for a user with nil digest" do 
    assert_not @user.authenticated?('')
  end

  test "login with remembering" do 
    log_in_as(@user, remember_me: "1")
    assert_not_empty cookies['remember_token']
  end

  test "login without remembering" do 
    # Log in to set the cookie.
    log_in_as(@user, remember_me: '1')
    # Log in again and verify that the cookie is deleted.
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end 

end
