require 'test_helper'

class SaintsControllerTest < ActionController::TestCase
  setup do
    @saint = saints(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:saints)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create saint" do
    assert_difference('Saint.count') do
      post :create, :saint => @saint.attributes
    end

    assert_redirected_to saint_path(assigns(:saint))
  end

  test "should show saint" do
    get :show, :id => @saint.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @saint.to_param
    assert_response :success
  end

  test "should update saint" do
    put :update, :id => @saint.to_param, :saint => @saint.attributes
    assert_redirected_to saint_path(assigns(:saint))
  end

  test "should destroy saint" do
    assert_difference('Saint.count', -1) do
      delete :destroy, :id => @saint.to_param
    end

    assert_redirected_to saints_path
  end
end
