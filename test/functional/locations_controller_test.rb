require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  setup do
    @location = locations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create location" do
    assert_difference('Location.count') do
      post :create, location: { ac_bus_accessible: @location.ac_bus_accessible, address: @location.address, bart_accessible: @location.bart_accessible, city: @location.city, directions: @location.directions, email: @location.email, fax: @location.fax, free_parking: @location.free_parking, free_street_parking: @location.free_street_parking, hours: @location.hours, latitude: @location.latitude, longitude: @location.longitude, muni_bus_accessible: @location.muni_bus_accessible, muni_train_accessible: @location.muni_train_accessible, name: @location.name, organization_id: @location.organization_id, paid_parking_lot: @location.paid_parking_lot, parking_fees: @location.parking_fees, parking_meters: @location.parking_meters, phone: @location.phone, public_transportation_stop: @location.public_transportation_stop, wheelchair_accessible: @location.wheelchair_accessible, zipcode: @location.zipcode }
    end

    assert_redirected_to location_path(assigns(:location))
  end

  test "should show location" do
    get :show, id: @location
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @location
    assert_response :success
  end

  test "should update location" do
    put :update, id: @location, location: { ac_bus_accessible: @location.ac_bus_accessible, address: @location.address, bart_accessible: @location.bart_accessible, city: @location.city, directions: @location.directions, email: @location.email, fax: @location.fax, free_parking: @location.free_parking, free_street_parking: @location.free_street_parking, hours: @location.hours, latitude: @location.latitude, longitude: @location.longitude, muni_bus_accessible: @location.muni_bus_accessible, muni_train_accessible: @location.muni_train_accessible, name: @location.name, organization_id: @location.organization_id, paid_parking_lot: @location.paid_parking_lot, parking_fees: @location.parking_fees, parking_meters: @location.parking_meters, phone: @location.phone, public_transportation_stop: @location.public_transportation_stop, wheelchair_accessible: @location.wheelchair_accessible, zipcode: @location.zipcode }
    assert_redirected_to location_path(assigns(:location))
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete :destroy, id: @location
    end

    assert_redirected_to locations_path
  end
end
