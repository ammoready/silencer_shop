require 'silencer_shop/api'

module SilencerShop
  class Dealer < Base

    include SilencerShop::API

    ENDPOINTS = {
      confirmed: "dealer/login".freeze
    }

    def initialize(client)
      @client = client
    end

    def confirmed?(dealer_username: '', dealer_password: '')
      post_request(
        ENDPOINTS[:confirmed],
        { username: dealer_username, password: dealer_password },
        auth_header(@client.access_token)
      ).success?
    end

  end
end
