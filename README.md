# BTCJam Check

Command line tool to check open loan offers, grouping them and separating those by your **selected favorite borrowers**.

Created and tested with **Ruby 2.2**.

## required gems

    require 'httparty'
    require 'nokogiri'
    require 'json'
    require 'csv'
    require 'yaml'
    require 'colorize'

### use
* [Download](https://github.com/altcointrading/btcjam-check/archive/master.zip) or clone this repo. 

````
  cd ~
  git clone https://github.com/altcointrading/btcjam-check
  cd btcjam-check*
```

* In your user dashboard on [BTCJam](https://btcjam.com)
  * The script won't let you invest but BTCJam requires you to register an app for you if you want to just screen open loan orders. 
  * So, register new API app. Neither name nor callback url are important at the moment. Fill in whatever.
* In `config.yaml`: 
  * Fill in your api "key" and secret (btcjam calls key "id")
  * Define user ids of your selected users (with good payment morality etc)

* Run `ruby do.rb`

### to do

* auth + login
* check if already invested
* invest
