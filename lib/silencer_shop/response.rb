module SilencerShop
  class Response

    attr_accessor :success

    def initialize(response)
      @response = response

      case @response
      when Net::HTTPUnauthorized
        SilencerShop::Error::NotAuthorized.new(@response.body)
      when Net::HTTPNotFound
        SilencerShop::Error::NotFound.new(@response.body)
      when Net::HTTPNoContent
        SilencerShop::Error::NoContent.new(@response.body)
      when Net::HTTPOK, Net::HTTPSuccess
        self.success = true
        _data = (JSON.parse(@response.body) if @response.body.present?)

        @data = case
        when _data.is_a?(Hash)
          _data.deep_symbolize_keys
        when _data.is_a?(Array)
          _data.map(&:deep_symbolize_keys)
        end
      else
        if @response.body =~ /unable to verify credentials/i
          SilencerShop::Error::NotAuthorized.new(@response.body)
        else
          raise SilencerShop::Error::RequestError.new(@response.body)
        end
      end
    end

    def [](key)
      @data&.[](key)
    end

    def body
      @data
    end

    def fetch(key)
      @data.fetch(key)
    end

    def success?
      !!success
    end

  end
end
