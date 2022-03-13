require "net/http"
require "json"

class ResourcesController < ApplicationController
  before_action :set_resource, only: [:show, :update, :destroy]

  # GET /resources
  def index
    @resources = Resource.all

    render json: @resources
  end

  # GET /resources/1
  def show
    render json: @resource
  end

  # POST /resources
  def create
    #pull out lat/long values
    latitude = resource_params[:latitude]
    longitude = resource_params[:longitude]

    #API
    revGeo = ENV["location_info"]
    # convert coordinates to address from api
    response = Net::HTTP.get(URI("https://api.tomtom.com/search/2/reverseGeocode/#{latitude}%2C#{longitude}.json?returnSpeedLimit=false&key=#{revGeo}"))
    #return json
    result = JSON.parse(response)

    #api data 
    addresses = result["addresses"][0]
    address = addresses["address"]
    #full address from api data 
    street_address = address.find{|e| e.include?("freeformAddress")}
    
    #action controller locks params so need to create a new object to alter values 
    new_resource_params = resource_params.to_h
    #add street address 
    new_resource_params[:street] = street_address[1]

    @resource = Resource.new(new_resource_params)
   
    if @resource.save
      render json: @resource, status: :created, location: @resource
    else
      render json: @resource.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /resources/1
  def update
    if @resource.update(resource_params)
      render json: @resource
    else
      render json: @resource.errors, status: :unprocessable_entity
    end
  end

  # DELETE /resources/1
  def destroy
    @resource.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @resource = Resource.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def resource_params
      params.require(:resource).permit(:latitude, :longitude, :education, :employment, :food, :health, :housing, :legal, :lgbtq, :money, :multicultural, :transportation, :description, :name)
    end
end