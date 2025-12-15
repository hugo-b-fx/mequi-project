require "test_helper"

class FavoriteCoachesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @rider = users(:two)
    @coach = coaches(:one)
  end

  test "should add coach to favorites when signed in" do
    sign_in @rider
    assert_difference("FavoriteCoach.count", 1) do
      post coach_favorite_path(@coach)
    end
    assert_redirected_to coach_path(@coach)
  end

  test "should remove coach from favorites when signed in" do
    sign_in @rider
    FavoriteCoach.create!(user: @rider, coach: @coach)

    assert_difference("FavoriteCoach.count", -1) do
      delete coach_favorite_path(@coach)
    end
    assert_redirected_to coach_path(@coach)
  end

  test "should redirect to login when not signed in" do
    post coach_favorite_path(@coach)
    assert_redirected_to new_user_session_path
  end

  test "should not add same coach twice" do
    sign_in @rider
    FavoriteCoach.create!(user: @rider, coach: @coach)

    assert_no_difference("FavoriteCoach.count") do
      post coach_favorite_path(@coach)
    end
  end
end
