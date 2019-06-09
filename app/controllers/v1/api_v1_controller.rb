module V1
  class ApiV1Controller < ApplicationController
    before_action :set_headers

    rescue_from ActiveRecord::RecordNotFound do
      render status: :not_found
    end

    private

    def set_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Expose-Headers'] = 'ETag'
      headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD'
      headers['Access-Control-Allow-Headers'] = '*,x-requested-with,Content-Type,If-Modified-Since,If-None-Match'
      headers['Access-Control-Max-Age'] = '86400'
    end
  end
end