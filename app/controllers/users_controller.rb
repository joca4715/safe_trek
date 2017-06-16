class UsersController < ApplicationController
  before_action :authorize, only: [:edit, :update, :logout]
  before_action :correct_user, only: [:edit, :update, :logout]

  def index
    if current_user && current_user.locations.size > 0
      @suggested_locations = user_location_service.suggested_locations.page(params[:page]).per(10)
      @gmaps_coordinates = user_location_service.gmaps_coordinates
      if params[:search]
        @searched_places = search.page(params[:page]).per(10) if search
      end
    elsif current_user && current_user.locations.size == 0
      @suggested_locations = user_location_service.suggested_locations.page(params[:page]).per(10)
      @gmaps_coordinates = user_location_service.gmaps_coordinates
      if params[:search]
        @searched_places = search.page(params[:page]).per(10) if search
      end
    else
      @searched_places = search.page(params[:page]).per(10) if search
    end
  end

  def show
    @user = User.find(params[:id])
    @user_city = @user.current_city
    @locations = Location.all.order("name").group_by(&:address).values
    @user_places = @locations.map{|a| a[0].address unless !a[0].address.include?(@user_city)}
    @user_locations = Location.where(address: @user_places)
    @near_locations = @user_locations.order("name").group_by(&:address).values
    @ids = @near_locations.map{|b| b[0].id}
    @places_list = Location.where(id: @ids).order("name")
    @suggested_locations = @places_list.page(params[:page]).per(10)
    @gmaps_coordinates = [@places_list.last.try(:latitude), @places_list.last.try(:longitude)]
  end

  def edit
    @user = User.find(params[:id])
    @gmaps_coordinates = user_location_service.gmaps_coordinates
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "You have successfully signed up"
      redirect_to nearby_shelters_path(current_user.current_city, current_user.id)
    else
      render 'new'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path
      flash[:notice] = "Updated Profile"
    else
      redirect_to edit_user_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :email, :current_city, :current_state, :current_country, :password, :password_confirmation, :bio)
  end

  def location_params
    params.require(:location).permit(:address, :latitude, :longitude, :user_id, :gmaps)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def user_location_service
    UserLocationService.new(current_user, search_term)
  end

  def search_term
    params[:search] if params[:search].present?
  end

  def search
    user_location_service.search_result
  end

end
