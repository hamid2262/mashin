require 'test_helper'

class InternalColorsControllerTest < ActionController::TestCase
  setup do
    @internal_color = internal_colors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:internal_colors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create internal_color" do
    assert_difference('InternalColor.count') do
      post :create, internal_color: { name: @internal_color.name, visible: @internal_color.visible }
    end

    assert_redirected_to internal_color_path(assigns(:internal_color))
  end

  test "should show internal_color" do
    get :show, id: @internal_color
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @internal_color
    assert_response :success
  end

  test "should update internal_color" do
    patch :update, id: @internal_color, internal_color: { name: @internal_color.name, visible: @internal_color.visible }
    assert_redirected_to internal_color_path(assigns(:internal_color))
  end

  test "should destroy internal_color" do
    assert_difference('InternalColor.count', -1) do
      delete :destroy, id: @internal_color
    end

    assert_redirected_to internal_colors_path
  end
end
