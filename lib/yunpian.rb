require 'yunpian/version'
require 'yunpian/request'

module Yunpian
  SEND_GATEWAY = 'http://yunpian.com/v1/sms/send.json'

  @timeout = 5

  class << self
    attr_accessor :apikey, :signature, :timeout

    def send_to(recipients, content)
      params = {
        apikey: Yunpian.apikey,
        mobile: Array(recipients).join(','),
        text:   content
      }
      Request.new(SEND_GATEWAY, params).perform
    end

    def send_to!(recipients, content)
      params = {
        apikey: Yunpian.apikey,
        mobile: Array(recipients).join(','),
        text:   content
      }
      Request.new(SEND_GATEWAY, params).perform!
    end
  end

  class RequestException < StandardError; end
end
