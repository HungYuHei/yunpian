require 'test_helper'

class TestYunpian < Minitest::Test
  def setup
    ::Yunpian.signature = 'signature'
    ::Yunpian.apikey = 'apikey'
  end

  def test_configuration
    refute_nil ::Yunpian.signature
    refute_nil ::Yunpian.apikey
    refute_nil ::Yunpian.timeout
  end

  def test_signature_static
    assert_equal "signature", ::Yunpian.signature
  end

  def test_signature_dynamic
    ::Yunpian.signature = ->{ I18n.locale == :en ? "SIGNATURE" : "签名" }

    I18n.locale = :en
    assert_equal "SIGNATURE", ::Yunpian.signature

    I18n.locale = :cn
    assert_equal "签名", ::Yunpian.signature
  end

  def test_that_it_has_a_version_number
    refute_nil ::Yunpian::VERSION
  end

  def test_send_to_success
    stub_request(:post, 'http://yunpian.com/v1/sms/send.json').
      to_return(status: 200, body: %Q({"code":0,"msg":"OK"}))

    refute_nil ::Yunpian.send_to('1234567890', 'hello')
  end

  def test_send_to_override_signature_success
    stub_request(:post, 'http://yunpian.com/v1/sms/send.json').
      with(body: hash_including(text: "【signature2】hello")).
      to_return(status: 200, body: %Q({"code":0,"msg":"OK"}))

    refute_nil ::Yunpian.send_to('1234567890', 'hello', '【signature2】')
  end

  def test_send_to_with_array_success
    stub_request(:post, 'http://yunpian.com/v1/sms/send.json').
      to_return(status: 200, body: %Q({"code":0,"msg":"OK"}))

    refute_nil ::Yunpian.send_to(%w(12345 67890), 'hello')
  end

  def test_send_to_fail
    stub_request(:post, 'http://yunpian.com/v1/sms/send.json').
      to_return(status: 200, body: %Q({"code":1,"msg":"FAIL"}))

    refute_nil ::Yunpian.send_to('1234567890', 'hello')
  end

  def test_send_to_band_success
    stub_request(:post, 'http://yunpian.com/v1/sms/send.json').
      to_return(status: 200, body: %Q({"code":0,"msg":"OK"}))

    assert ::Yunpian.send_to!('1234567890', 'hello')
  end

  def test_send_to_band_override_signature_success
    stub_request(:post, 'http://yunpian.com/v1/sms/send.json').
      with(body: hash_including(text: "【signature2】hello")).
      to_return(status: 200, body: %Q({"code":0,"msg":"OK"}))

    refute_nil ::Yunpian.send_to!('1234567890', 'hello', '【signature2】')
  end

  def test_send_to_band_fail
    stub_request(:post, 'http://yunpian.com/v1/sms/send.json').
      to_return(status: 200, body: %Q({"code":1,"msg":"FAIL"}))

    assert_raises(::Yunpian::RequestException) { ::Yunpian.send_to!('1234567890', 'hi') }
  end

  def test_get_account_info_success
    stub_request(:post, ::Yunpian::ACCOUNT_GATEWAY).
      to_return(status: 200, body: %Q({"code":0,"msg":"OK","user":{"nick": "name"}}))

    refute_nil ::Yunpian.account_info
  end
end
