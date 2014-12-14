#!/usr/bin/env ruby
#
require 'highline/import'
require_relative '../lib/stock_tip/yaml_interface/account_info'
default_directory = ARGV[0] ||"./data/current"
account = StockTip::AccountInfo.new(default_directory)
account_info = {}
unless account.exists?
  puts "I don't see an account in #{default_directory}, let me prompt you "+
    "to create one"
  account_info[:broker] = ask("broker name?")
  account_info[:sell_fee] = ask("sell fee?")
  account_info[:buy_fee] = ask("buy fee?")
  puts "creating account"
  account.create(account: account_info)
end
