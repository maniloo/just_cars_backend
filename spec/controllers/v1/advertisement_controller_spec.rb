require "rails_helper"

RSpec.describe V1::AdvertisementsController do
  describe "GET /advertisements" do

    describe "when advertisements exist" do
      let!(:adv1) {create :advertisement}
      let!(:adv2) {create :advertisement}

      let(:exected_responsoe) {
        {
            "advertisements" => [
                {
                    "id" => adv1.id,
                    "title" => adv1.title,
                    "description" => adv1.description,
                    "price" => adv1.price,
                    "image_path" => "",
                },
                {
                    "id" => adv2.id,
                    "title" => adv2.title,
                    "description" => adv2.description,
                    "price" => adv2.price,
                    "image_path" => "",
                }
            ]
        }
      }
      it "returns JSON list of advertisements" do
        get :index

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(exected_responsoe)
      end
    end

    describe "when advertisements not exist" do
      let(:exected_responsoe) {
        {
            "advertisements" => []
        }
      }

      it "returns empty array" do
        get :index
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(exected_responsoe)
      end
    end
  end


  describe "GET /advertisements/:id" do
    describe "when advertisement with given param exists" do
      let!(:adv1) {create :advertisement}
      let(:exected_responsoe) {
        {
        "id" => adv1.id,
            "title" => adv1.title,
            "description" => adv1.description,
            "price" => adv1.price,
            "image_path" => "",

        }
      }

      it "returns JSON with advertisement with given param" do
        get :show, params: { id: adv1.id }

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(exected_responsoe)
      end
    end

    describe "when advertisement with given params not exists" do
      it "returns 404 status (Not Found)" do
        get :show, params: { id: "some unexisted id" }

        expect(response.status).to eq(404)
      end
    end
  end

  describe "POST /advertisements" do
    describe "when given params are correct" do
      let(:iamge_path) {"spec/mocks/images/exapmle_car_image.png"}
      let(:image64) do
        File.open(iamge_path, 'rb') do |img|
          'data:image/png;base64,' + Base64.strict_encode64(img.read)
        end
      end

      let(:request_params) {
        {
            "title" => "Ford Mustang",
            "description" => "New car for brave man",
            "price" => "125000",
            "image_data" => image64,
        }
      }

      it "returns 201 status (created), creats new object and attach image" do
        post :create, params: request_params

        expect(response.status).to eq(201)
        expect(Advertisement.count).to eq(1)
        expect(Advertisement.first.image.attached?).to eq(true)
      end
    end

    describe "when given params are incorrect" do
      let(:exected_responsoe) {
        {
            "error" => "Title can't be blank and Price can't be blank"
        }
      }
      it "returns 400 status (Bad Request) and object is not created" do
        post :create, params: {}

        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)).to eq(exected_responsoe)
      end
    end
  end

  describe "DELETE /advertisements/:id" do
    describe "when advertisement with given param exists" do
      let!(:adv1) {create :advertisement}

      it "returns 204 status (No Content) and object is deleted" do
        delete :destroy, params: { id: adv1.id }

        expect(response.status).to eq(204)
        expect(Advertisement.count).to eq(0)
      end
    end

    describe "when advertisement with given params not exists" do
      it "returns 404 status (Not Found)" do
        delete :destroy, params: { id: "some unexisted id" }

        expect(response.status).to eq(404)
      end
    end
  end
end
