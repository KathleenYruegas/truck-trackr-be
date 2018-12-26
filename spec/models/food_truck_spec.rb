require 'rails_helper'

RSpec.describe FoodTruck, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:food_type) }
    it { should validate_presence_of(:contact_name) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_presence_of(:email) }
  end
  describe "relationships" do
    it { should have_many(:food_truck_cities) }
    it { should have_many(:cities).through(:food_truck_cities) }
  end
end
