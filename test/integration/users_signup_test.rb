require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end


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
    assert_select "div#error_explanation"
    assert_select "div.alert-danger"
  end

  test "valid sign up information with account activation" do
    get signup_path
    assert_difference "User.count",1 do
      post users_path, user: {
        name: "Example User",
        email: "user@example.com",
        password: "foobar",
        password_confirmation: "foobar"
      }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    #try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?
    #invalid activation token
    get edit_account_activation_path("invalid activation")
    assert_not is_logged_in?
    #valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # valid log in
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end
