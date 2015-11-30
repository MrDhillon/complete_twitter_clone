require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:dante)
  end

  test "unsuccessful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "",
                                    email: "foobar@email.com",
                                    password: "foo",
                                    password_confirmation: "bar"
                                  }
    assert_template "users/edit"
  end

  test "successful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "dante bosco"
    email = "cosco@email.com"
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password: "",
                                    password_confirmation: ""
                                  }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
end
