require 'test_helper'

class BasketsControllerTest < ActionController::TestCase
  setup do
    @basket = baskets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:baskets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create basket" do
    assert_difference('Basket.count') do
      post :create, :basket => @basket.attributes
    end

    assert_redirected_to basket_path(assigns(:basket))
  end

  test "should show basket" do
    get :show, :id => @basket.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @basket.to_param
    assert_response :success
  end

  test "should update basket" do
    put :update, :id => @basket.to_param, :basket => @basket.attributes
    assert_redirected_to basket_path(assigns(:basket))
  end

  test "should destroy basket" do
    assert_difference('Basket.count', -1) do
      delete :destroy, :id => @basket.to_param
    end

    assert_redirected_to baskets_path
  end
end
