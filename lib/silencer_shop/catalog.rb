module SilencerShop
  class Catalog < Base

    def initialize(options = {})
      requires!(options, :username, :password)

      @client = SilencerShop::Client.new(username: options[:username], password: options[:password])
    end

    def self.all(options = {})
      requires!(options, :username, :password)

      new(options).all
    end

    def all
      @client.product_feed.catalog.body.map { |item| map_hash(item) }
    end

    private

    def map_hash(item)
      {
        name: item[:ShortDescription],
        model: item[:Model],
        upc: item[:UniversalProductCode],
        item_identifier: item[:DealerPartNumber],
        long_description: item[:LongDescription],
        short_description: item[:ShortDescription],
        category: item[:CategoryCode],
        price: item[:Price],
        map_price: item[:MARP],
        msrp: item[:MSRP],
        quantity: item[:Quantity],
        weight: item[:Weight],
        brand: item[:Make],
        mfg_number: item[:ManufacturerPartNumber],
        features: {
          length: item[:Length],
          width: item[:Width],
          height: item[:Height],
          other_info: item[:OtherInfo],
          firearm_type: item[:FirearmType],
          allow_backorder: item[:AllowBackorder],
          restrictions_info: item[:RestrictionsInfo],
          size_info: item[:SizeInfo],
          is_restricted: item[:IsRestricted],
          dropship_ok: item[:DropShipOk],
          image_name: item[:LargeImagePath].split('/')[-1]
        }
      }
    end

  end
end
