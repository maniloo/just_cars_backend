module V1
  class AdvertisementsController < ApiV1Controller
    def index
      render json: serialize_collection(Advertisement.all)
    end

    def show
      render json: serialize_element(Advertisement.find(params[:id]))
    end

    def create
      if advertisement_creator.call
        render json: serialize_element(advertisement_creator.advertisement), status: :created
      else
        render json: { error: advertisement_creator.advertisement.errors.full_messages.to_sentence}, status: :bad_request
      end
    end

    def destroy
      advertisement = Advertisement.find(params[:id])
      advertisement.image.purge
      advertisement.destroy
    end

    private

    def serialize_element(advertisement)
      {
          id: advertisement.id,
          title: advertisement.title,
          description: advertisement.description,
          price: advertisement.price,
          image_path: advertisement.image.attached? ? url_for(advertisement.image) : ""
      }
    end

    def serialize_collection(advertisements)
      {
          advertisements: advertisements.map do |advertisement|
            serialize_element(advertisement)
          end
      }
    end

    def advertisement_creator
      @advertisement_creator ||= AdvertisementCraetor.new(
          object_paramas: advertisement_params,
          image_data: params[:image_data]
      )
    end

    def advertisement_params
      params.permit(:title, :price, :description)
    end
  end
end

