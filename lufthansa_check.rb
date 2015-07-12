#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'

LUFT_URL = "https://www.lufthansa.com/deeplink/mybookings?country=us&language=en&filekey=XXXXXX&lastname=YYYYYYYY&page=BKGD"
RESERVED_SEATS = ["44A","44C"]
NOTIFICATION_EMAIL = "email@email.com"

begin
  page = Nokogiri::HTML(open(LUFT_URL)) 

  seats = page.css("strong[class=seat-num]").map(&:text)
  all_good = seats.reject{|seat| seat=='---'}.uniq.sort == RESERVED_SEATS

  # No need to send email, cron whil do it for us
  #`echo "Seats: #{seats}" | mail -s "Lufthansa fucked it up again!" #{NOTIFICATION_EMAIL}` unless all_good

  if all_good
    puts "All good! Seats are still #{RESERVED_SEATS}"
  else
    STDERR.puts  "FUCK! They changed to #{seats}"
  end
rescue Exception => e
  STDERR.puts e.message
  STDERR.puts e.backtrace
end