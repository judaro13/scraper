#install webmock and vcr gems

require 'rubygems'
require_relative "../lib/scraper"
require "test/unit"

class TestScraper < Test::Unit::TestCase

  def test_valid_year
    es = EncScraper.new("ASDF", "2022")
    res = es.valid_year?
    assert_equal(false, res )

    es = EncScraper.new("ASDF", "2016")
    res = es.valid_year?
    assert_equal(true, res )

  end

  def test_parse_day
    t = 1520400612
    es = EncScraper.new("ASDF", "2022")
    res = es.parse_day(Time.at(t))
    assert_equal("2018-03-07", res )
  end

  def test_run
    es = EncScraper.new("ASDF", "2017")
    res = es.run
    assert_equal(true, res.include?("Argumentos") )

    es = EncScraper.new("8672e846-9c89-4dbf-a1cc-b85a2da5abe1", "2016")
    res = es.run
    assert_equal(0, res[:invoices])
  end

end
