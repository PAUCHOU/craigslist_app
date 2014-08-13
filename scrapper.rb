# scrapper.rb
require 'nokogiri'
require 'open-uri'


def filter_links(rows, regex)
  # takes in rows and returns uses
  # regex to only return links 
  # that have "pup", "puppy", or "dog"
  # keywords
  results = []
  rows.each do |row|
    link_text = row.css(".hdrlnk").text
    if link_text.match(regex) && link_text.match(regex).length
       uri = row.css(".hdrlnk").attribute("href")
       url = "http://sfbay.craigslist.org" + uri
       results.push url
    end
  end
  results
end


def get_todays_rows(doc, date_str)
  #  1.) open chrome console to look in inside p.row to see
  #  if there is some internal date related content
                              
  #  2.) figure out the class that you'll need to select the
  #   date from a row
  dates_arr = []

  rows = doc.css(".row")

  rows.each do |row|

    if row.css(".date").text == date_str
      dates_arr.push row
    end

  end

    dates_arr
end


def get_page_results
  url = "today.html"
  Nokogiri::HTML(open(url))
end


def search(date_str)
  doc = get_page_results
  only_today_rows = get_todays_rows(doc, date_str)
  regex = /(dog|pup)/
  links = filter_links(only_today_rows, regex)
  puts links

end


# want to learn more about 
# Time in ruby??
#   http://www.ruby-doc.org/stdlib-1.9.3/libdoc/date/rdoc/Date.html#strftime-method
today = Time.now.strftime("%b %d")
search(today)
