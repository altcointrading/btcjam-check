require 'rubygems'
require 'httparty'
require 'nokogiri'
require 'json'
require 'csv'
require 'colorize'
require 'yaml'

require_relative 'btcjam'

puts "BTCJam Followees New Inactive Fundings".blue

jam = Btcjam.new
profiles = jam.ids
base = jam.base

profiles.each do |userid|

  url = base.to_s + "/users/" + userid.to_s
  puts " === Calling profile #{url} === "

  page = HTTParty.get(url)
  doc = Nokogiri::HTML(page)

  listing = Array.new

  doc.css("#my_loans-table").search('tr').each do |row|
   if row.search('td').to_s.include? ("progress")

     puts "Found funding in prog:".green

      row.search('a').each do |link|
       target = link['href']
        listing.push( target )
       puts base.green + target.green
        loanid = jam.loanid( target )
       puts "Loan id: #{loanid}".green
      end

   else
     puts "... not in progress, next ..."
   end
  end

  puts " === END #{url} === "

end#profiles
