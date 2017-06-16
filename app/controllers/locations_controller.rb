class LocationsController < ApplicationController
  before_action :authorize, only: [:index, :generate_shelters, :logout]
  before_action :correct_user, only: [:generate_shelters, :logout]

  def index
    if params[:search]
      @searched_locations = search.page(params[:page]).per(10) if search
    end
    @local_locations = user_location_service.suggested_locations.page(params[:page]).per(10)
    @gmaps_coordinates = user_location_service.gmaps_coordinates
  end

  def generate_shelters
    @search_locations = Location.shelters_search(user.current_city, user.id)
    redirect_to root_path
  end

  def show
    @location = Location.find(params[:id])
    if current_user
      @suggested_locations = user_location_service.suggested_locations.page(params[:page]).per(10)
      @gmaps_coordinates = user_location_service.gmaps_coordinates
      @walking_distance = Location.walking_distance(user.current_city, @location.address, @location)
      @bicycling_distance = Location.bicycling_distance(user.current_city, @location.address, @location)
    elsif !current_user && @location.latitude && @location.longitude
      @gmaps_coordinates = [@location.latitude, @location.longitude]
    end
  end

  private

  def location_params
    params.require(:location).permit(:address, :latitude, :longitude, :user_id, :gmaps)
  end

  def user
    current_user
  end

  def correct_user
    @user = current_user
    redirect_to(root_path) unless current_user?(@user)
  end

  def user_params
    params.require(:user).permit(:current_city)
  end

  def user_location_service
    UserLocationService.new(current_user, search_term)
  end

  def search_term
    params[:search] if params[:search].present?
  end

  def local_search
    user_location_service.search_rslt
  end

  def search
    user_location_service.search_result
  end

end
