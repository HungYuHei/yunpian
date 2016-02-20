$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'yunpian'

require 'minitest/autorun'
require 'webmock/minitest'

module I18n
  class << self
    attr_accessor :locale
  end
end
