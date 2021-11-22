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
      endpoint = ENDPOINTS[:confirmed]
      creds = { username: dealer_username, password: dealer_password }
      headers = [
        *auth_header(@client.access_token),
        *content_type_header('application/json'),
      ].to_h

      post_request(endpoint, creds, headers).success?
    end

  end
end
