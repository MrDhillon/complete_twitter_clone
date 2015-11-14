require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid sign up" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {
        name: "harman",
        email: "harman@email.com",
        password: "foo",
        password_confirmation: "bar"
      }
    end
    assert_template 'users/new'
  end

  test "valid sign up" do
    get signup_path
    assert_difference "User.count",1 do
      post_via_redirect users_path, user: {
        name: "Aman",
        email: "aman@email.com",
        password: "password",
        password_confirmation: "password"
      }
    end
    assert_template 'users/show'
  end

end
