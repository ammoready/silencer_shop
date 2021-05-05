module SilencerShop
  class Error < StandardError

    class NoContent < SilencerShop::Error; end
    class NotAuthorized < SilencerShop::Error; end
    class NotFound < SilencerShop::Error; end
    class RequestError < SilencerShop::Error; end
    class TimeoutError < SilencerShop::Error; end

  end
end
