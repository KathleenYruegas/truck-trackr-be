require 'rails_helper'

describe "Food Truck API" do
  describe 'GET food trucks index end point' do
    it 'user can get all food trucks' do
        truck_1, truck_2, truck_3 = create_list(:food_truck, 3)

        get '/api/v1/food_trucks'

        expect(response).to be_successful

        trucks_response = JSON.parse(response.body)
        expect(trucks_response).to be_a(Hash)
        expect(trucks_response).to have_key('data')
        expect(trucks_response['data']).to be_a(Array)
        expect(trucks_response['data'].length).to eq(3)
        expect(trucks_response['data'][0]).to be_a(Hash)
        expect(trucks_response['data'][0]).to have_key('type')
        expect(trucks_response['data'][0]['type']).to eq('food_truck')
        expect(trucks_response['data'][0]).to have_key('id')
        expect(trucks_response['data'][0]['id']).to eq("#{truck_1.id}")
        expect(trucks_response['data'][0]).to have_key('attributes')
        expect(trucks_response['data'][0]['attributes']).to have_key('name')
        expect(trucks_response['data'][0]['attributes']['name']).to eq(truck_1.name)
    end
  end
  describe 'GET food truck show end point' do
    it 'user can get food truck attributes' do
        truck = create(:food_truck)
        city = create(:city)
        create(:food_truck_city, food_truck: truck, city: city)
        create(:open_date, food_truck: truck)

        get "/api/v1/food_trucks/#{truck.id}"

        expect(response).to be_successful

        trucks_response = JSON.parse(response.body)

        expect(trucks_response).to be_a(Hash)
        expect(trucks_response).to have_key('data')
        expect(trucks_response['data'].length).to eq(4)
        expect(trucks_response['data']).to be_a(Hash)
        expect(trucks_response['data']).to have_key('type')
        expect(trucks_response['data']['type']).to eq('food_truck')
        expect(trucks_response['data']).to have_key('id')
        expect(trucks_response['data']['id']).to eq("#{truck.id}")
        expect(trucks_response['data']).to have_key('attributes')
        expect(trucks_response['data']['attributes']).to have_key('name')
        expect(trucks_response['data']['attributes']['name']).to eq(truck.name)
        expect(trucks_response['data']['attributes']).to have_key('food_type')
        expect(trucks_response['data']['attributes']['food_type']).to eq(truck.food_type)
        expect(trucks_response['data']['attributes']).to have_key('contact_name')
        expect(trucks_response['data']['attributes']['contact_name']).to eq(truck.contact_name)
        expect(trucks_response['data']['attributes']).to have_key('phone')
        expect(trucks_response['data']['attributes']['phone']).to eq(truck.phone)
        expect(trucks_response['data']['attributes']).to have_key('website')
        expect(trucks_response['data']['attributes']['website']).to eq(truck.website)
        expect(trucks_response['data']['attributes']).to have_key('logo_image')
        expect(trucks_response['data']['attributes']['logo_image']).to have_key('url')
        expect(trucks_response['data']).to have_key('relationships')
        expect(trucks_response['data']['relationships']).to be_a(Hash)
        expect(trucks_response['data']['relationships']).to have_key('cities')
        expect(trucks_response['data']['relationships']['cities']).to be_a(Hash)
        expect(trucks_response['data']['relationships']['cities']).to have_key('data')
        expect(trucks_response['data']['relationships']['cities']['data']).to be_a(Array)
        expect(trucks_response['data']['relationships']['cities']['data'].length).to eq(1)
        expect(trucks_response['data']['relationships']['cities']['data'][0]).to be_a(Hash)
        expect(trucks_response['data']['relationships']['cities']['data'][0]).to have_key('id')
        expect(trucks_response['data']['relationships']['cities']['data'][0]['id']).to eq(city.id.to_s)
        expect(trucks_response['data']['relationships']['cities']['data'][0]).to have_key('type')
        expect(trucks_response['data']['relationships']['cities']['data'][0]['type']).to eq('city')
        expect(trucks_response['included'].length).to eq(2)
        expect(trucks_response['included'][0]).to have_key('id')
        expect(trucks_response['included'][0]['id']).to eq(city.id.to_s)
        expect(trucks_response['included'][0]).to have_key('type')
        expect(trucks_response['included'][0]['type']).to eq('city')
        expect(trucks_response['included'][0]).to have_key('attributes')
        expect(trucks_response['included'][0]['attributes']).to have_key('name')
        expect(trucks_response['included'][0]['attributes']['name']).to eq(city.name)
    end
    it "returns a 404 if food_truck does not exist" do
      truck = create(:food_truck)

      get "/api/v1/food_trucks/10000"

      food_truck_data = JSON.parse(response.body)
      expect(response.status).to eq(404)
      expect(food_truck_data).to have_key("message")
      expect(food_truck_data["message"]).to eq("Food Truck not found with ID 10000")
    end
  end
  describe 'POST food truck show end point' do
    it 'user can get post new truck with required attributes' do
        payload = {
          name: "Hell On Wheels",
          food_type: "Barbecue",
          contact_name: "Sultan Charles",
          phone: "666-666-6666",
          email: "hellonwheelss666@hotmail.com",
          uid: "123abc"
        }

        post "/api/v1/food_trucks", params: payload

        expect(response).to be_successful

        trucks_response = JSON.parse(response.body)

        expect(trucks_response).to be_a(Hash)
        expect(trucks_response).to have_key('data')
        expect(trucks_response['data'].length).to eq(4)
        expect(trucks_response['data']).to be_a(Hash)
        expect(trucks_response['data']).to have_key('type')
        expect(trucks_response['data']['type']).to eq('food_truck')
        expect(trucks_response['data']).to have_key('id')
        expect(trucks_response['data']['id']).to_not eq(nil)
        expect(trucks_response['data']).to have_key('attributes')
        expect(trucks_response['data']['attributes']).to_not have_key('uid')
        expect(trucks_response['data']['attributes']).to have_key('name')
        expect(trucks_response['data']['attributes']['name']).to eq(payload[:name])
        expect(trucks_response['data']['attributes']).to have_key('food_type')
        expect(trucks_response['data']['attributes']['food_type']).to eq(payload[:food_type])
        expect(trucks_response['data']['attributes']).to have_key('contact_name')
        expect(trucks_response['data']['attributes']['contact_name']).to eq(payload[:contact_name])
        expect(trucks_response['data']['attributes']).to have_key('phone')
        expect(trucks_response['data']['attributes']['phone']).to eq(payload[:phone])
        expect(trucks_response['data']['attributes']).to have_key('email')
        expect(trucks_response['data']['attributes']['email']).to eq(payload[:email])
    end
    it "returns a 400 if payload does not have all required parameters" do
      payload = {
        food_type: "Barbecue",
        contact_name: "Sultan Charles",
        phone: "666-666-6666",
        email: "hellonwheelss666@hotmail.com"
      }

      post "/api/v1/food_trucks"

      food_truck_data = JSON.parse(response.body)

      expect(response.status).to eq(400)
      expect(food_truck_data).to have_key("message")
      expect(food_truck_data["message"]).to eq("Failed")
    end
  end
  describe 'PUT food truck end point' do
    it 'user can update a truck with attributes' do
      truck = create(:food_truck)

      payload = {
        contact_name: "Sultan Charles",
        phone: "666-666-6666",
        uid: truck.uid
      }

      put "/api/v1/food_trucks/#{truck.id}", params: payload

      expect(response).to be_successful

      trucks_response = JSON.parse(response.body)

      expect(trucks_response).to be_a(Hash)
      expect(trucks_response).to have_key('data')
      expect(trucks_response['data'].length).to eq(4)
      expect(trucks_response['data']).to be_a(Hash)
      expect(trucks_response['data']).to have_key('type')
      expect(trucks_response['data']['type']).to eq('food_truck')
      expect(trucks_response['data']).to have_key('id')
      expect(trucks_response['data']['id']).to eq(truck.id.to_s)
      expect(trucks_response['data']).to have_key('attributes')
      expect(trucks_response['data']['attributes']).to have_key('name')
      expect(trucks_response['data']['attributes']['name']).to eq(truck.name)
      expect(trucks_response['data']['attributes']).to have_key('food_type')
      expect(trucks_response['data']['attributes']['food_type']).to eq(truck.food_type)
      expect(trucks_response['data']['attributes']).to have_key('contact_name')
      expect(trucks_response['data']['attributes']['contact_name']).to eq(payload[:contact_name])
      expect(trucks_response['data']['attributes']).to have_key('phone')
      expect(trucks_response['data']['attributes']['phone']).to eq(payload[:phone])
      expect(trucks_response['data']['attributes']).to have_key('email')
      expect(trucks_response['data']['attributes']['email']).to eq(truck.email)
    end
    it "returns a 404 if food truck is not found" do
      truck = create(:food_truck)

      payload = {
        food_type: "Barbecue",
        contact_name: "Sultan Charles",
        phone: "666-666-6666",
        email: "hellonwheelss666@hotmail.com",
        uid: "123jjf"
      }

      put "/api/v1/food_trucks/10000", params: payload

      food_truck_data = JSON.parse(response.body)

      expect(response.status).to eq(404)
      expect(food_truck_data).to have_key("message")
      expect(food_truck_data["message"]).to eq("Food Truck not found.")
    end
  end
  describe "food truck delete api endpoint" do
    it "deletes a selected food truck" do
      truck = create(:food_truck)

      payload = {
        "uid": truck.uid
      }

      delete "/api/v1/food_trucks/#{truck.id}", params: payload

      expect(response).to be_successful
      expect(response.status).to eq(204)

      get "/api/v1/food_trucks/#{truck.id}"

      brewery_data = JSON.parse(response.body)
      expect(response.status).to eq(404)
      expect(brewery_data).to have_key('message')
      expect(brewery_data['message']).to eq("Food Truck not found with ID #{truck.id}")
    end
    it("returns a 404 if truck is not found") do
      truck = create(:food_truck)

      payload = {
        "uid": "63hfj38"
      }

      delete "/api/v1/food_trucks/100", params: payload

      brewery_data = JSON.parse(response.body)
      expect(response.status).to eq(404)
      expect(brewery_data).to have_key('message')
      expect(brewery_data['message']).to eq("Food Truck not found with ID 100")
    end
  end
end
