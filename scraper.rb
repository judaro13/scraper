require 'time'
require 'pry'
require './enconta_server'

class EncScraper
  # DAY_IN_MINUTES = 86400
  attr_accessor :batch_days_size, :id, :iterations, :year, :last_day, :first_dag, :total_invoices

  def initialize(id, year)
    return "Invalid year" unless valid_year?(year)

    self.id = id
    self.year = year
    last_day = Time.parse(year+"-01-01")
    batch_days_size = 20
    iterations = 0
    total_invoices = 0
  end

  def run
    finish_day = Time.parse(year+"-12-31")
    while last_day <= finish_day

    end
  end

  def valid_year?(year)
    y = Integer(year || '')
    y > 1980 && y <= Time.now.year
  rescue
    false
  end
end

binding.pry
