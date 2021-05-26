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
        purchase_order ffl_information customer_email customer_phone customer_name
        address_line_1 city state zip line_items dealer_part_number quantity
      ).freeze
    }

    ENDPOINTS = {
      submit:  "commerce/order".freeze,
      fetch:   "commerce/order/%s?emailAddress=%s".freeze,
      invoice: "commerce/order/pdf/%s?emailAddress=%s".freeze
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

    def fetch(order_id, customer_email)
      endpoint = ENDPOINTS[:fetch] % [order_id, customer_email]

      get_request(endpoint, auth_header(@client.access_token))
    end

    def invoice(order_id, customer_email)
      endpoint = ENDPOINTS[:invoice] % [order_id, customer_email]

      get_request(endpoint, auth_header(@client.access_token))
    end

  end
end
