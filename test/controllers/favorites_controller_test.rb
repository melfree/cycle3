require 'test_helper'

class FavoritesControllerTest < ActionController::TestCase
  setup do
    @favorite = favorites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create favorite" do
    assert_difference('Favorite.count') do
      post :create, params: { favorite: { user_email: @favorite.user_email, user_id: @favorite.user_id, user_name: @favorite.user_name } }
    end

    assert_redirected_to favorite_path(Favorite.last)
  end

  test "should show favorite" do
    get :show, params: { id: @favorite }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @favorite }
    assert_response :success
  end

  test "should update favorite" do
    patch :update, params: { id: @favorite, favorite: { user_email: @favorite.user_email, user_id: @favorite.user_id, user_name: @favorite.user_name } }
    assert_redirected_to favorite_path(@favorite)
  end

  test "should destroy favorite" do
    assert_difference('Favorite.count', -1) do
      delete :destroy, params: { id: @favorite }
    end

    assert_redirected_to favorites_path
  end
end
