require 'silencer_shop/api'

module SilencerShop
  class ProductFeed < Base

    include SilencerShop::API

    ENDPOINTS = {
      catalog:      "productfeed/catalog".freeze,
      availability: "productfeed/availability".freeze
    }

    def initialize(client)
      @client = client
    end

    def catalog
      get_request(ENDPOINTS[:catalog], auth_header(@client.access_token))
    end

    def availability
      get_request(ENDPOINTS[:availability], auth_header(@client.access_token))
    end

  end
end
