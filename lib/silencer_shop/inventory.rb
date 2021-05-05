module SilencerShop
  class Inventory < Base

    def initialize(options = {})
      requires!(options, :username, :password)

      @client = SilencerShop::Client.new(username: options[:username], password: options[:password])
    end

    def self.all(options = {})
      requires!(options, :username, :password)

      new(options).all
    end
    class << self; alias_method :quantity, :all; end

    def all
      @client.product_feed.availability.body.map { |item| map_hash(item) }
    end

    private

    def map_hash(item)
      {
        item_identifier: item[:DealerPartNumber],
        quantity: item[:Quantity],
        price: item[:Price],
      }
    end

  end
end
