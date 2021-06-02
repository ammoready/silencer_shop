require 'silencer_shop/base'
require 'silencer_shop/version'

require 'silencer_shop/api'
require 'silencer_shop/catalog'
require 'silencer_shop/client'
require 'silencer_shop/dealer'
require 'silencer_shop/error'
require 'silencer_shop/inventory'
require 'silencer_shop/order'
require 'silencer_shop/product_feed'
require 'silencer_shop/response'
require 'silencer_shop/user'

module SilencerShop

  class << self
    attr_accessor :config
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield(config)
  end

  def self.sandbox?
    !!config.sandbox
  end


  class Configuration
    attr_accessor :proxy_address, :proxy_port, :sandbox

    def initialize
      @proxy_address ||= nil
      @proxy_port    ||= nil
      @sandbox       ||= true
    end
  end

end
