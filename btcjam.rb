
class Btcjam

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

end#class
