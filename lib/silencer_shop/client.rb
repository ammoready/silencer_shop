require 'silencer_shop/api'
require 'silencer_shop/dealer'
require 'silencer_shop/order'
require 'silencer_shop/product_feed'

module SilencerShop
  class Client < Base

    include SilencerShop::API

    TOKEN_RESOURCE = {
      development: 'https://silencershopstaging.onmicrosoft.com/SilencerShop.Portal'.freeze,
      production:  '<waiting for this value>'.freeze
    }
    TOKEN_URL = {
      development: 'silencershopstaging.onmicrosoft.com/oauth2/token'.freeze,
      production:  '<waiting for this value'.freeze
    }

    attr_accessor :access_token

    def initialize(options = {})
      requires!(options, :username, :password)
      @options = options

      authenticate!
    end

    def product_feed
      @product_feed ||= SilencerShop::ProductFeed.new(self)
    end

    def order
      @order ||= SilencerShop::Order.new(self)
    end

    def dealer
      @dealer ||= SilencerShop::Dealer.new(self)
    end

    private

    def authenticate!
      environment = SilencerShop.sandbox? ? :development : :production
      token_resource, token_url = [TOKEN_RESOURCE[environment], TOKEN_URL[environment]]
      request_data = [
        ['grant_type', 'client_credentials'],
        ['resource', CGI.escape(token_resource)],
        ['client_id', CGI.escape(@options[:username])],
        ['client_secret', CGI.escape(@options[:password])]
      ].map { |a| a.join('=') }.join('&')

      response = post_request(
        token_url,
        request_data,
        content_type_header('application/x-www-form-urlencoded'),
        'https://login.microsoftonline.com'
      )

      if response[:access_token].present?
        self.access_token = response[:access_token]
      else
        raise SilencerShop::Error::NotAuthorized.new(response.body)
      end
    end

  end
end
