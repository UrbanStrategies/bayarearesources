require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase
  setup do
    @organization = organizations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organizations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization" do
    assert_difference('Organization.count') do
      post :create, organization: { address: @organization.address, city: @organization.city, description: @organization.description, email: @organization.email, goal_1: @organization.goal_1, goal_2: @organization.goal_2, goal_3: @organization.goal_3, goal_4: @organization.goal_4, latitude: @organization.latitude, longitude: @organization.longitude, name: @organization.name, phone: @organization.phone, population: @organization.population, website: @organization.website, zipcode: @organization.zipcode }
    end

    assert_redirected_to organization_path(assigns(:organization))
  end

  test "should show organization" do
    get :show, id: @organization
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @organization
    assert_response :success
  end

  test "should update organization" do
    put :update, id: @organization, organization: { address: @organization.address, city: @organization.city, description: @organization.description, email: @organization.email, goal_1: @organization.goal_1, goal_2: @organization.goal_2, goal_3: @organization.goal_3, goal_4: @organization.goal_4, latitude: @organization.latitude, longitude: @organization.longitude, name: @organization.name, phone: @organization.phone, population: @organization.population, website: @organization.website, zipcode: @organization.zipcode }
    assert_redirected_to organization_path(assigns(:organization))
  end

  test "should destroy organization" do
    assert_difference('Organization.count', -1) do
      delete :destroy, id: @organization
    end

    assert_redirected_to organizations_path
  end
end
