module SilencerShop
  class Response

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
        _data = (JSON.parse(@response.body) if @response.body.present?)

        @data = case
        when _data.is_a?(Hash)
          _data.deep_symbolize_keys
        when _data.is_a?(Array)
          _data.map(&:deep_symbolize_keys)
        end
      else
        raise SilencerShop::Error::RequestError.new(@response.body)
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
      !!self[:success] && self[:errors].empty?
    end

  end
end
