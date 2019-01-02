require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: {user: {name: "", email: "user@invalid",
                                       password: "foo",
                                       gender: User.genders[:male],
                                       date_of_birth: "1992/12/12",
                                       password_confirmation: "bar"}}
    end
    assert_template "users/new"
  end

  test "valid signup information" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: {user: {name: "Example User",
                                       email: "user@example.com",
                                       password: "password",
                                       gender: User.genders[:male],
                                       date_of_birth: "1992/12/12",
                                       password_confirmation: "password"}}
    end
    follow_redirect!
    assert_template "users/show"
  end
end
