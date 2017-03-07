require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
   test "invalid signup information" do 
      get signup_path
      assert_no_difference 'User.count' do 
         post users_path, params: { user: { name: "",
                                            email: "user@invalid",
                                            password:              "foo",
                                            password_confirmation: "foo"}}
      end
      assert_template 'users/new'
   end

   test "valid signup infromation" do 
      get signup_path
      assert_difference 'User.count', 1 do 
         post users_path, params: { user: { name:  "Example User",
                                            email: "user@example.com",
                                            password:              "thuan274",
                                            password_confirmation: "thuan274" } }
      end   
      follow_redirect!
      assert_template 'users/show'
      assert_not_nil(flash)
   end
end
