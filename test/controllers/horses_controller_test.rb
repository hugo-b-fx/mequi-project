require "test_helper"

class HorsesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @rider = users(:two)
    @horse = horses(:two)
  end

  # === NEW ===
  test "should get new when signed in" do
    sign_in @rider
    get new_horse_path
    assert_response :success
  end

  test "should redirect new when not signed in" do
    get new_horse_path
    assert_redirected_to new_user_session_path
  end

  # === CREATE ===
  test "should create horse when signed in" do
    sign_in @rider
    assert_difference("Horse.count", 1) do
      post horses_path, params: {
        horse: {
          name: "Nouveau Cheval",
          age: 5,
          breed: "Selle Français",
          discipline: "CSO"
        }
      }
    end
    assert_redirected_to dashboard_user_path(@rider)
  end

  # === EDIT ===
  test "should get edit for own horse" do
    sign_in @rider
    get edit_horse_path(@horse)
    assert_response :success
  end

  test "should redirect edit when not owner" do
    other_user = users(:one)
    sign_in other_user
    get edit_horse_path(@horse)
    assert_redirected_to root_path
  end

  # === UPDATE ===
  test "should update own horse" do
    sign_in @rider
    patch horse_path(@horse), params: {
      horse: { name: "Thunder Updated" }
    }
    assert_redirected_to dashboard_user_path(@rider)
    @horse.reload
    assert_equal "Thunder Updated", @horse.name
  end

  # === DESTROY ===
  test "should destroy own horse without bookings" do
    sign_in @rider
    # Create a new horse without bookings for deletion test
    new_horse = @rider.horses.create!(name: "ToDelete", age: 3)
    assert_difference("Horse.count", -1) do
      delete horse_path(new_horse)
    end
    assert_redirected_to dashboard_user_path(@rider)
  end
end
