class AdvertisementCraetor
  attr_reader :advertisement

  def initialize(object_paramas:, image_data:)
    @object_paramas = object_paramas
    @image_data = image_data
  end

  def call
    @advertisement = Advertisement.new(@object_paramas)

    if @advertisement.save
      add_image_attachment unless @image_data.nil?
      true
    else
      false
    end
  end

  private

  def add_image_attachment
    unless @image_data[/(image\/[a-z]{3,4})|(application\/[a-z]{3,4})/] == ''
      content_type = @image_data[/(image\/[a-z]{3,4})|(application\/[a-z]{3,4})/]
      content_type = content_type[/\b(?!.*\/).*/]
      contents = @image_data.sub /data:((image|application)\/.{3,}),/, ''
      decoded_data = Base64.decode64(contents)
      filename = 'doc_' + Time.zone.now.to_s.tr(" ", "_") + '.' + content_type
      File.open("#{Rails.root}/tmp/#{filename}", 'wb') do |f|
        f.write(decoded_data)
      end
      @advertisement.image.attach(io: File.open("#{Rails.root}/tmp/#{filename}"), filename: filename)
      FileUtils.rm("#{Rails.root}/tmp/#{filename}")
    end
  end
end