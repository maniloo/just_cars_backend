require 'rails_helper'

RSpec.describe Advertisement, type: :model do
  it "should be not valid without price" do
    advertisement = Advertisement.new(title: "Ford Mustang")

    expect(advertisement).not_to be_valid
    expect(advertisement.errors[:price]).to eq(["can't be blank"])
  end

  it "should be not valid without title" do
    advertisement = Advertisement.new(price: 200000)

    expect(advertisement).not_to be_valid
    expect(advertisement.errors[:title]).to eq(["can't be blank"])
  end
end
