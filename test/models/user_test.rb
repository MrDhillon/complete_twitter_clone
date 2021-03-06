require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new( name: "harman", email: "harman@email.com",
                      password: "123456", password_confirmation: "123456")
  end

  test "should be valid" do
    assert @user.valid?, "#{@user.inspect}"
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email should be valid type" do
    valid_emails = %w[user@email.com USER@foo.COM A_US-ER@foo.bar.org
                      first.last@foo.jp alice+bob@baz.cn]
    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"
    end
  end

  test "email validation should reject invalid emails" do
    invalid_emails = %w[user@example,com user_at_foo.org user.name@example.
                      foo@bar_baz.com foo@bar+baz.com]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should not be valid"
    end
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be downcase" do
    new_email = "DeggQWE@dasdQWe.com"
    @user.email = new_email
    @user.save
    assert_equal new_email.downcase, @user.reload.email
  end

  test "pass should have minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated micropost should be destroyed" do
    @user.save
    @user.microposts.create!(content: "lorem ipsum")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    micheal = users(:dante)
    archer = users(:archer)
    assert_not micheal.following?(archer)
    micheal.follow(archer)
    assert micheal.following?(archer)
    assert archer.followers.include?(micheal)
    micheal.unfollow(archer)
    assert_not micheal.following?(archer)  
  end

  test "feed should have the right posts" do
    dante = users(:dante)
    archer = users(:archer)
    lana = users(:lana)
    # post from followed user
    lana.microposts.each do |post_following|
      assert dante.feed.include?(post_following)
    end
    # post from self
    dante.microposts.each do |post_self|
      assert dante.feed.include?(post_self)
    end

    archer.microposts.each do |post_unfollowed|
      assert_not dante.feed.include?(post_unfollowed)
    end
  end

end
