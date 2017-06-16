class UserLocationService
  attr_reader :current_user, :search_term

  def initialize(current_user, search_term = nil)
    @current_user = current_user
    @search_term = search_term
  end

  def user_city
    if current_user && current_user.locations.size > 0
      current_user.current_city
    elsif current_user && current_user.locations.size == 0
      "Los Angeles"
    end
  end

  def locations
    Location.all.order("name").group_by(&:address).values
  end

  def user_places
    locations.map{|a| a[0].address unless !a[0].address.include?(user_city)}
  end

  def user_locations
    Location.where(address: user_places)
  end

  def near_locations
    user_locations.order("name").group_by(&:address).values
  end

  def place_ids
    near_locations.map{|b| b[0].id}
  end

  def places_list
    Location.where(id: place_ids)
  end

  def suggested_locations
    places_list.order("name")
  end

  def gmaps_coordinates
    q = []
    if current_user && current_user.locations.size > 0
      q << places_list.last.try(:latitude)
      q << places_list.last.try(:longitude)
    elsif current_user && current_user.locations.size == 0
      q << places_list.last.try(:latitude)
      q << places_list.last.try(:longitude)
    else
      [34.0522, -118.2437]
    end
  end

  def all_places
    Location.all.search(search_term).order("name").group_by(&:address).values
  end

  def places
    Location.search(search_term).order("name").group_by(&:address).values
  end

  def identification
    all_places.map{|l| l[0].id} if all_places
  end

  def identify
    places.map{|l| l[0].id} if places
  end

  def search_result
    Location.where(id: identification) if identification
  end

  def search_rslt
    Location.where(id: identify) if identify
  end

end
