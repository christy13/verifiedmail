require 'test_helper'

class MhashesControllerTest < ActionController::TestCase
  setup do
    @mhash = mhashes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mhashes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mhash" do
    assert_difference('Mhash.count') do
      post :create, mhash: { hash: @mhash.hash, user_id: @mhash.user_id }
    end

    assert_redirected_to mhash_path(assigns(:mhash))
  end

  test "should show mhash" do
    get :show, id: @mhash
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mhash
    assert_response :success
  end

  test "should update mhash" do
    put :update, id: @mhash, mhash: { hash: @mhash.hash, user_id: @mhash.user_id }
    assert_redirected_to mhash_path(assigns(:mhash))
  end

  test "should destroy mhash" do
    assert_difference('Mhash.count', -1) do
      delete :destroy, id: @mhash
    end

    assert_redirected_to mhashes_path
  end
end
