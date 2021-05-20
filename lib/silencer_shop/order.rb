require 'silencer_shop/api'

module SilencerShop
  class Order < Base

    include SilencerShop::API

    SUBMIT_ATTRS = {
      permitted: %i(
        purchase_order account_number other_information notes customer_email customer_phone
        customer_name company_name address_line_1 address_line_2 ffl_information city state
        zip shipping_method sales_tax_collected line_items dealer_part_number quantity price
        universal_product_code description
      ).freeze,
      required: %i(
        purchase_order customer_email customer_phone customer_name company_name address_line_1
        ffl_information city state zip sales_tax_collected line_items dealer_part_number quantity
      ).freeze
    }

    ENDPOINTS = {
      submit:  "commerce/order".freeze,
      fetch:   "commerce/order/%s".freeze,
      invoice: "commerce/order/pdf/%s".freeze
    }

    def initialize(client)
      @client = client
    end

    def submit(order_data)
      requires!(order_data, *SUBMIT_ATTRS[:required])

      endpoint = ENDPOINTS[:submit]
      headers = [
        *auth_header(@client.access_token),
        *content_type_header('application/json'),
      ].to_h

      order_data = standardize_body_data(order_data, SUBMIT_ATTRS[:permitted])

      post_request(endpoint, order_data, headers)
    end

    def fetch(order_id)
      endpoint = ENDPOINTS[:fetch] % order_id

      get_request(endpoint, auth_header(@client.access_token))
    end

    def invoice(order_id)
      endpoint = ENDPOINTS[:invoice] % order_id

      get_request(endpoint, auth_header(@client.access_token))
    end

  end
end
