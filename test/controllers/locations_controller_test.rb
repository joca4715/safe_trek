require 'test_helper'

class LocationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get locations_index_url
    assert_response :success
  end

  test "should get generate_shelters" do
    get locations_generate_shelters_url
    assert_response :success
  end

  test "should get show" do
    get locations_show_url
    assert_response :success
  end

end
