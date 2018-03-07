require 'uri'
require 'net/http'
require 'net/https'

class EncServer
  def self.get_invoices(params)
    return nil unless valid_params?(params)
    url = "http://34.209.24.195/facturas?id="
    url += "#{params[:id]}&start=#{params[:start]}"
    url += "&finish=#{params[:finish]}"

    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri)
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
      http.request(req)
    }
    return parse_response(res.body)
  end

  def self.parse_response(response)
    Integer(response || '')
  rescue ArgumentError
    nil
  end

  def self.valid_params?(params)
    ![params[:start], params[:finish], params[:id]].include?(nil)
  end
end
