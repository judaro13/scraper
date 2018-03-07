require 'time'
require_relative 'enconta_server'

class EncScraper
  attr_accessor :id, :year

  def initialize(id, year)
    self.id = id
    self.year = year
  end

  def run
    return "Invalid year" unless valid_year?

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
        batch_days_size += rand(1..10) if invoices < 70   # increment the batch_days_size if the response is less than 70 invoices
        total_invoices += invoices
        last_day = new_last + day_in_minutes
      else
        batch_days_size -= rand(1..10) # decreasethe batch_days_size if there is not a valid response
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

  def valid_year?
    y = Integer(year || '')
    return y > 1980 && y <= Time.now.year - 1
  rescue
    false
  end
end
