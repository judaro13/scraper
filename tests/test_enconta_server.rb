#install webmock and vcr gems

require 'rubygems'
require_relative "../lib/enconta_server"
require "test/unit"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "tests/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

class TestEncServer < Test::Unit::TestCase

  def test_parse_response
    res = EncServer.parse_response("5")
    assert_equal(5, res[:invoices] )
    assert_equal(nil, res[:error] )

    res = EncServer.parse_response("invalid")
    assert_equal(nil, res[:invoices] )
    assert_not_equal(nil, res[:error] )
  end

  def test_valid_params
    res = EncServer.valid_params?({})
    assert_equal(false, res )
    res = EncServer.valid_params?({finish: "12-02-02"})
    assert_equal(false, res )
    res = EncServer.valid_params?({finish: "2012-02-02", start: "2011-02-02"})
    assert_equal(false, res )
    res = EncServer.valid_params?({finish: "2017-02-05", start: "2017-02-02", id: "ASDF"})
    assert_equal(true, res )
  end

  def test_get_invoices
    VCR.use_cassette("invoices") do
      res = EncServer.get_invoices({finish: "2017-02-05", start: "2017-02-02", id: "8672e846-9c89-4dbf-a1cc-b85a2da5abe1"})
      assert_equal(12, res[:invoices] )
      assert_equal(nil, res[:error] )
    end
  end

end
