require 'net/http'

module SilencerShop
  module API

    USER_AGENT = "SilencerShopRubyGem/#{SilencerShop::VERSION}".freeze
    API_URL = {
      development: 'https://silencershopportaldebug.azurewebsites.net/api'.freeze,
      production:  'https://silencershopportal.azurewebsites.net/api'.freeze
    }
    FILE_UPLOAD_ATTRS = {
      permitted: %i( file_name file_type file_contents ).freeze,
      reqired:   %i( file_type file_contents ).freeze,
    }

    def get_request(endpoint, headers = {}, root_url = nil)
      request = Net::HTTP::Get.new(request_url(endpoint, root_url))

      submit_request(request, {}, headers)
    end

    def post_request(endpoint, data = {}, headers = {}, root_url = nil)
      request = Net::HTTP::Post.new(request_url(endpoint, root_url))

      submit_request(request, data, headers)
    end

    def post_file_request(endpoint, file_data, headers = {}, root_url = nil)
      request = Net::HTTP::Post.new(request_url(endpoint, root_url))

      submit_file_request(request, file_data, headers)
    end

    private

    def submit_request(request, data, headers)
      set_request_headers(request, headers)

      request.body = data.is_a?(Hash) ? data.to_json : data

      process_request(request)
    end

    def submit_file_request(request, file_data, headers)
      boundary = ::SecureRandom.hex(15)

      headers.merge!(content_type_header("multipart/form-data; boundary=#{boundary}"))

      build_multipart_request_body(request, file_data, boundary)
      set_request_headers(request, headers)
      process_request(request)
    end

    def process_request(request)
      uri = URI(request.path)

      response = Net::HTTP.start(uri.host, uri.port, SilencerShop.config.proxy_address, SilencerShop.config.proxy_port, use_ssl: true) do |http|
        http.request(request)
      end

      SilencerShop::Response.new(response)
    end

    def build_multipart_request_body(request, file_data, boundary)
      file_type     = file_data[:file_type]
      file_contents = file_data[:file_contents]
      file_name     = file_data[:file_name] || "ffl-document.#{file_type}"
      content_type  = "application/#{file_data[:file_type]}"

      body = []
      body << "--#{boundary}\r\n"
      body << "Content-Disposition: form-data; name=\"file\"; filename=\"#{file_name}\"\r\n"
      body << "Content-Type: #{content_type}\r\n"
      body << "\r\n"
      body << "#{file_contents}\r\n"
      body << "--#{boundary}--\r\n"

      request.body = body.join
    end

    def set_request_headers(request, headers)
      request['User-Agent'] = USER_AGENT

      headers.each { |header, value| request[header] = value }
    end

    def auth_header(token)
      { 'Authorization' => "Bearer #{token}" }
    end

    def content_type_header(type)
      { 'Content-Type' => type }
    end

    def request_url(endpoint, root_url = nil)
      root_url ||= (SilencerShop.sandbox? ? API_URL[:development] : API_URL[:production])

      [root_url, endpoint].join('/')
    end

    def standardize_body_data(submitted_data, permitted_data_attrs)
      _submitted_data = submitted_data.deep_transform_keys(&:to_sym)
      permitted_data = {}

      _submitted_data.each do |k1, v1|
        if permitted_data_attrs.include?(k1)
          if v1.is_a?(Array)
            permitted_data[k1] = []

            v1.each do |sub_data|
              permitted_sub_data = {}
              sub_data.each { |k2, v2| permitted_sub_data[k2] = v2 if permitted_data_attrs.include?(k2) }
              permitted_data[k1] << permitted_sub_data
            end
          else
            permitted_data[k1] = v1
          end
        end
      end

      permitted_data.deep_transform_keys { |k| k.to_s.camelize(:lower) }
    end

  end
end
