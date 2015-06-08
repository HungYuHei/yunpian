require 'yunpian/version'
require 'yunpian/request'

module Yunpian
  @timeout = 5

  class << self
    attr_accessor :apikey, :signature, :timeout

    def send_to(recipients, content)
      Request.new(recipients, content).perform
    end

    def send_to!(recipients, content)
      Request.new(recipients, content).perform!
    end
  end

  class RequestException < StandardError; end
end
