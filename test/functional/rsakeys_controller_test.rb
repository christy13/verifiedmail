require 'test_helper'

class RsakeysControllerTest < ActionController::TestCase
  setup do
    @rsakey = rsakeys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rsakeys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rsakey" do
    assert_difference('Rsakey.count') do
      post :create, rsakey: { e_private_key: @rsakey.e_private_key, public_key: @rsakey.public_key, user_id: @rsakey.user_id }
    end

    assert_redirected_to rsakey_path(assigns(:rsakey))
  end

  test "should show rsakey" do
    get :show, id: @rsakey
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rsakey
    assert_response :success
  end

  test "should update rsakey" do
    put :update, id: @rsakey, rsakey: { e_private_key: @rsakey.e_private_key, public_key: @rsakey.public_key, user_id: @rsakey.user_id }
    assert_redirected_to rsakey_path(assigns(:rsakey))
  end

  test "should destroy rsakey" do
    assert_difference('Rsakey.count', -1) do
      delete :destroy, id: @rsakey
    end

    assert_redirected_to rsakeys_path
  end
end
