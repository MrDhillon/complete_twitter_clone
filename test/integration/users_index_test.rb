require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:dante)
    @user2 = users(:archer)
  end

  test "index inclusing pagination" do
    log_in_as(@user)
    get users_path
    assert_template "users/index"
    assert_select "div.pagination"
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @user
        assert_select 'a[href=?]', user_path(user), text: 'delete', method: :delete
      end
    end
  end

  test "admin user can delete users" do
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@user2)
    end
  end

  test "index as non-admin" do
    log_in_as(@user2)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
