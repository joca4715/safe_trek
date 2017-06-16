class Location < ApplicationRecord
  require 'json'

  require 'uri'

  require 'net/http'

  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy

  validates :address,
  presence: true


  def self.search(query)
    wildcarded_query = "%#{query}%"
    where(
      "address ILIKE :address OR name ILIKE :name",
      address: wildcarded_query,
      name: wildcarded_query
    )
  end

  def self.shelters_search(current_city, current_user_id)
    uri = URI.parse("https://maps.googleapis.com/maps/api/place/textsearch/json?query=homeless%20services+in+#{current_city.delete(' ')}&key=#{ENV["GOOGLE_PLACES_API_KEY"]}")
    response = Net::HTTP.get_response(uri)
    shelters = JSON.parse(response.body)["results"]
    if current_user_id
      location_attrs = []

      shelters.each_with_index do |shelter|
        location_attrs << {address: shelter['formatted_address'], latitude: shelter['geometry']['location']['lat'], longitude: shelter['geometry']['location']['lng'], name: shelter['name'], rating: shelter['rating'], user_id: current_user_id}
      end

      Location.bulk_insert values: location_attrs
    end
  end

  # def self.shelters_search(current_city, current_user_id)
  #   uri = URI.parse("https://maps.googleapis.com/maps/api/place/textsearch/json?query=homeless%20services+in+#{current_city.delete(' ')}&key=#{ENV["GOOGLE_PLACES_API_KEY"]}")
  #   response = Net::HTTP.get_response(uri)
  #   shelters = JSON.parse(response.body)["results"]
  #   if current_user_id
  #     shelters.each_with_index do |shelter|
  #       Location.create(address: shelter['formatted_address'], latitude: shelter['latitude'], longitude: shelter['longitude'], name: shelter['name'], rating: shelter['rating'], user_id: current_user_id)
  #     end
  #   end
  # end


  def self.walking_distance(current_city, address, user_location)
    uri = URI.parse("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&avoid=tolls|highways|ferries|indoor&origins=#{current_city}&destinations=#{address.delete(' ')}&mode=walking&key=#{ENV["GOOGLE_MAPS_DISTANCE_MATRIX_API_KEY"]}")
    response = Net::HTTP.get_response(uri)
    distance = JSON.parse(response.body)["rows"]
    distance = distance[0]
    eta = JSON.parse(response.body)["rows"]
    eta = eta[0]
    if user_location && distance != {"elements"=>[{"status"=>"NOT_FOUND"}]} && eta != {"elements"=>[{"status"=>"NOT_FOUND"}]}
      "#{address} is #{distance["elements"][0]["distance"]["text"]} away from #{current_city} and it would take #{eta["elements"][0]["duration"]["text"]} via walking."
    else
      "N/A"
    end
  end

  def self.bicycling_distance(current_city, address, user_location)
    uri = URI.parse("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&avoid=tolls|highways|ferries|indoor&origins=#{current_city}&destinations=#{address.delete(' ')}&mode=bicycling&key=#{ENV["GOOGLE_MAPS_DISTANCE_MATRIX_API_KEY"]}")
    response = Net::HTTP.get_response(uri)
    distance = JSON.parse(response.body)["rows"]
    distance = distance[0]
    eta = JSON.parse(response.body)["rows"]
    eta = eta[0]
    puts "\nTHE DISTANCE OBJECT IS: #{distance}"
    puts "\nTHE ETA OBJECT IS: #{eta}\n"
    if user_location && distance != {"elements"=>[{"status"=>"NOT_FOUND"}]} && eta != {"elements"=>[{"status"=>"NOT_FOUND"}]}
      "#{address} is #{distance["elements"][0]["distance"]["text"]} away from #{current_city} and it would take #{eta["elements"][0]["duration"]["text"]} via bicycling."
    else
      "N/A"
    end
  end

end
