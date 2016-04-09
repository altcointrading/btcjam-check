
class Btcjam

  @@basic =  ["amount","title","description","rate","listing_score"]
  @@personal = ["btcjam_score_numeric","positive_percentage_reputation","facebook_friend_count","paypal_account_date","id"]
  @@dealbreaker_val = 0.55

  def switcher
    puts "##############################\n  BTC Jam Loans Screening\n##############################".white.on_green
    puts
    puts "Choose action: "
    puts " = silently refresh listing data (r)"
    puts " = view all new listings (a)"
    puts " = view only listings by your favorite users (f)"
    puts " = quit (q)"
    ok = gets.chomp!
    if ok == "r"
      self.reload
      puts "Reloaded <ENTER>".green
      gets
      self.switcher
    elsif ok == "a"
      self.response
      puts "Finished. Enter to display options. <ENTER>".green
      gets
      self.switcher
    elsif ok == "f"
      self.favs
      puts "Finished. Enter to display options. <ENTER>".green
      gets
      self.switcher
    elsif ok == "q"
      puts "bye"
      abort
    end
  end

  def key
    conf = YAML::load_file('config.yaml')
    return conf['key']
  end
  def secret
    conf = YAML::load_file('config.yaml')
    return conf['secret']
  end
  def ids
    conf = YAML::load_file('config.yaml')
    return conf['userids']
  end

  def base
    base = "https://btcjam.com"
    return base
  end

  def loanid url
     chunks = []
     url.split("listings/").each do |piece|
       chunks.push piece
     end
     tail = []
     chunks[1].to_s.split("-").each do |piece|
       tail.push piece
     end
     loanid = tail[0]
     return loanid
  end

 def reload #silently

   profiles = self.ids
   key = self.key
   secret = self.secret
   tocall = "https://btcjam.com/api/v1/listings?appid=" + key.to_s + "&secret=" + secret.to_s
   uri = URI.parse( tocall )
   response = Net::HTTP.get_response(uri)
   data = JSON.parse(response.body)
   outer = Array.new
   data.each do |item|
   inner = Hash.new
    dealbreaker = item['listing']['user']['btcjam_score_numeric']
     basic = @@basic
     personal = @@personal
      if dealbreaker > @@dealbreaker_val

        item['listing'].each do |loan|
          key = loan[0]
          val = loan[1]
          if key == "description"
           val.gsub! '<p>', ''
           val.gsub! '</p>', ''
          end
          basic.each do |b|
            if ( key == b )
              inner[key] = val
            end#loop
          end#block
        end#item

        item['listing']['user'].each do |user|
          key = user[0]
          val = user[1]
            if ( key == "id" )
              inner[key] = val
              profiles.each do |id|
                if id == val
                  inner["favorite"] = true
                end
              end
            end#id fav
            personal.each do |b|
              if ( key == b )
                inner[key] = val
              end#loop
            end#block
         end#personal
      end#dealbreaker
    outer.push(inner)
  end#data each do
   all = outer.to_json
   File.open( "filtered.json", "w+") do |f|
   f.puts(all)
   end#puts
 end#reload

 def response
   profiles = self.ids
   key = self.key
   secret = self.secret
   tocall = "https://btcjam.com/api/v1/listings?appid=" + key.to_s + "&secret=" + secret.to_s
   puts "\nHold on ... \n"
   uri = URI.parse( tocall )
   response = Net::HTTP.get_response(uri)
   data = JSON.parse(response.body)
   outer = Array.new
   data.each do |item|
    inner = Hash.new
    dealbreaker = item['listing']['user']['btcjam_score_numeric']
      basic = @@basic
      personal = @@personal

        if dealbreaker > @@dealbreaker_val

        item['listing'].each do |loan|
          key = loan[0]
          val = loan[1]
          if key == "description"
           val.gsub! '<p>', ''
           val.gsub! '</p>', ''
          end
          basic.each do |b|
            if ( key == b )
              puts " = #{key}: #{val}"
              inner[key] = val
            end#loop
          end#block
        end#item

        item['listing']['user'].each do |user|
          key = user[0]
          val = user[1]
            if ( key == "id" )
              inner[key] = val
              profiles.each do |id|
                if id == val
                  puts "Your favorite user".green
                  inner["favorite"] = true
                end
              end
            end#id fav
            personal.each do |b|
              if ( key == b )
                puts " = User Info - #{key}: #{val}"
                inner[key] = val
              end#loop
            end#block
         end#personal
         puts "\n         ***\n"
      end#dealbreaker
    outer.push(inner)
   end
   all = outer.to_json
   File.open( "filtered.json", "w+") do |f|
   f.puts(all)
   end#puts
 end#response

 def favs
   puts "\nHold on ...\n"
   self.reload
   file = File.read("filtered.json")
   data = JSON.parse(file)
   data.each do |a|
    if a['favorite'] == true
     puts "\nFavorite borrower:\n#{a['title']}\n#{a['description']}\n#{a['amount']}BTC\nRate: #{a['rate']}"
     self.progress( a['id'] )
     puts "Link to profile: https://btcjam.com/users/#{a['id']}\n         ***\n"
    end
   end
 end#favs


 def progress userid

   base = self.base

     url = base.to_s + "/users/" + userid.to_s
     page = HTTParty.get(url)
     doc = Nokogiri::HTML(page)
       doc.css("#my_loans-table").search('tr').each do |row|

          if row.search('td').to_s.include? ("progress")

             row.search('a').each do |link|
              target = link['href']
              puts "Link to open loan: #{base}#{target}"
             end

          end

       end
 end#progress


end#class
