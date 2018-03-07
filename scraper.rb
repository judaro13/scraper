require 'time'
require './enconta_server'

class EncScraper
  attr_accessor :batch_days_size, :id, :iterations, :year, :total_invoices

  def initialize(id, year)
    raise "Invalid year" unless valid_year?(year)
    self.id = id
    self.year = year
  end

  def run
    finish_day = Time.parse(year+"-12-31")
    last_day = Time.parse(year+"-01-01")
    batch_days_size = 20
    iterations = 0
    total_invoices = 0

    while last_day <= finish_day
      print "."
      day_in_minutes = 86400
      new_last = last_day + batch_days_size * day_in_minutes
      new_last = finish_day if new_last > finish_day

      resp = EncServer.get_invoices({
        start: parse_day(last_day),
        finish: parse_day(new_last),
        id: id
      })

      return resp[:error] if !resp[:error].nil? && resp[:error].include?("Argumentos")

      invoices = resp[:invoices]
      if invoices.is_a? Integer
        batch_days_size += rand(1..10) if invoices < 70
        total_invoices += invoices
        last_day = new_last + day_in_minutes
      else
        batch_days_size -= rand(1..10)
        batch_days_size < 1 ? batch_days_size = 1 : nil
      end
      iterations += 1
    end

    puts "\niterations: #{iterations}"
    puts "Invoices: #{total_invoices}"
    return {iterations: iterations, invoices:total_invoices}
  end

  def parse_day(day)
    day.strftime("%Y-%m-%d")
  end

  def valid_year?(year)
    y = Integer(year || '')
    return y > 1980 && y <= Time.now.year - 1
  rescue
    false
  end
end
