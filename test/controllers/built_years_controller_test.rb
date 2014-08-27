require 'test_helper'

class BuiltYearsControllerTest < ActionController::TestCase
  setup do
    @built_year = built_years(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:built_years)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create built_year" do
    assert_difference('BuiltYear.count') do
      post :create, built_year: { engine_displacement: @built_year.engine_displacement, gearbox: @built_year.gearbox, year: @built_year.year }
    end

    assert_redirected_to built_year_path(assigns(:built_year))
  end

  test "should show built_year" do
    get :show, id: @built_year
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @built_year
    assert_response :success
  end

  test "should update built_year" do
    patch :update, id: @built_year, built_year: { engine_displacement: @built_year.engine_displacement, gearbox: @built_year.gearbox, year: @built_year.year }
    assert_redirected_to built_year_path(assigns(:built_year))
  end

  test "should destroy built_year" do
    assert_difference('BuiltYear.count', -1) do
      delete :destroy, id: @built_year
    end

    assert_redirected_to built_years_path
  end
end
