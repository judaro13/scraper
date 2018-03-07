
require_relative 'lib/scraper'


print "id: "
id = STDIN.gets
print "year: "
year = STDIN.gets

scraper = EncScraper.new(id.gsub("\n", ""), year.gsub("\n", ""))
puts scraper.run

# id = 8672e846-9c89-4dbf-a1cc-b85a2da5abe1
