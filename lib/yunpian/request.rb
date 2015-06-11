require 'net/http'
require 'json'

module Yunpian
  class Request
    def initialize(gateway, params)
      @gateway = gateway
      @params = params
    end

    def perform
      uri = URI(@gateway)
      req = Net::HTTP::Post.new(uri)
      req.set_form_data(@params)
      timeout = Yunpian.timeout

      res = Net::HTTP.start(uri.hostname,
                            uri.port,
                            read_timeout: timeout,
                            open_timeout: timeout) do |http|
        http.request(req)
      end

      JSON.parse(res.body)
    end

    def perform!
      json = perform
      json['code'] == 0 || raise(RequestException.new(json))
    end
  end
end
