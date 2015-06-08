require 'net/http'
require 'json'

module Yunpian
  class Request
    GATEWAY = 'http://yunpian.com/v1/sms/send.json'

    def initialize(recipients, content)
      @recipients = Array(recipients)
      @content = Yunpian.signature + content
    end

    def perform
      uri = URI(GATEWAY)
      req = Net::HTTP::Post.new(uri)

      req.set_form_data(
        apikey: Yunpian.apikey,
        mobile: @recipients.join(','),
        text: @content
      )

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
