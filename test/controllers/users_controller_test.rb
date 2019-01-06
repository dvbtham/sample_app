require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :tham
    @other_user = users :archer
  end
  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as @other_user
    get edit_user_path @user
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as @other_user
    patch user_path @user, params: {user: {name: @user.name,
                                           email: @user.email}}
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path id: @user, locale: :en
    log_in_as @user
    assert_redirected_to edit_user_path id: @user, locale: :en
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path @user, params: {user: {name:  name,
                                           email: email,
                                           password: "",
                                           password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
