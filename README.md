# btcjam-check
command line tool to check open loan offers, grouping them and separating those by your **selected favorite borrowers**.

## required gems

    require 'httparty'
    require 'nokogiri'
    require 'json'
    require 'csv'
    require 'yaml'
    require 'colorize'

### use
* [Download](https://github.com/altcointrading/btcjam-check/archive/master.zip) or clone this repo. 
  `cd ~`
  `git clone https://github.com/altcointrading/btcjam-check`
  `cd btcjam-check*`
* In your user dashboard on [BTCJam](https://btcjam.com)
  * register new API app. Neither name nor callback url are important. Fill in whatever.
* In `config.yaml`: 
  * fill in your api "key" and secret (btcjam calls key "id")
  * define user ids of your selected users (with good payment morality etc)

* Run `ruby do.rb`

### to do

* auth + login
* check if already invested
* invest
