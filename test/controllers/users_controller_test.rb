require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @rider = users(:two)
    @coach_user = users(:one)
  end

  # === SHOW (profil public) ===

  test "should get show without authentication" do
    get user_path(@rider)
    assert_response :success
  end

  test "should get show when signed in" do
    sign_in @rider
    get user_path(@rider)
    assert_response :success
  end

  # === DASHBOARD ===

  test "should get dashboard when signed in as owner" do
    sign_in @rider
    get dashboard_user_path(@rider)
    assert_response :success
  end

  test "should redirect dashboard when not signed in" do
    get dashboard_user_path(@rider)
    assert_redirected_to new_user_session_path
  end

  test "should redirect dashboard when accessing another users dashboard" do
    sign_in @coach_user
    get dashboard_user_path(@rider)
    assert_redirected_to root_path
  end

  # === EDIT ===

  test "should get edit when signed in as owner" do
    sign_in @rider
    get edit_user_path(@rider)
    assert_response :success
  end

  test "should redirect edit when not signed in" do
    get edit_user_path(@rider)
    assert_redirected_to new_user_session_path
  end

  test "should redirect edit when accessing another users edit" do
    sign_in @coach_user
    get edit_user_path(@rider)
    assert_redirected_to root_path
  end

  # === UPDATE ===

  test "should update user when signed in as owner" do
    sign_in @rider
    patch user_path(@rider), params: {
      user: {
        first_name: "Marie-Updated",
        last_name: "Martin-Updated",
        bio: "New bio"
      }
    }
    assert_redirected_to dashboard_user_path(@rider)
    @rider.reload
    assert_equal "Marie-Updated", @rider.first_name
  end

  test "should not update user when not signed in" do
    patch user_path(@rider), params: {
      user: { first_name: "Hacker" }
    }
    assert_redirected_to new_user_session_path
  end

  test "should not update another users profile" do
    sign_in @coach_user
    patch user_path(@rider), params: {
      user: { first_name: "Hacker" }
    }
    assert_redirected_to root_path
    @rider.reload
    assert_equal "Marie", @rider.first_name
  end
end
