require 'test_helper'

class BodyColorsControllerTest < ActionController::TestCase
  setup do
    @body_color = body_colors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:body_colors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create body_color" do
    assert_difference('BodyColor.count') do
      post :create, body_color: { name: @body_color.name, visible: @body_color.visible }
    end

    assert_redirected_to body_color_path(assigns(:body_color))
  end

  test "should show body_color" do
    get :show, id: @body_color
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @body_color
    assert_response :success
  end

  test "should update body_color" do
    patch :update, id: @body_color, body_color: { name: @body_color.name, visible: @body_color.visible }
    assert_redirected_to body_color_path(assigns(:body_color))
  end

  test "should destroy body_color" do
    assert_difference('BodyColor.count', -1) do
      delete :destroy, id: @body_color
    end

    assert_redirected_to body_colors_path
  end
end
