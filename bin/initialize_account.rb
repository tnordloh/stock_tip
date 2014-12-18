#!/usr/bin/env ruby
#
require 'highline/import'
require_relative '../lib/stock_tip/yaml_interface/account_info'
require_relative '../lib/stock_tip/yaml_interface/portfolio'
require_relative '../lib/stock_tip/cli/menu'
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
  account.create(info: account_info)
end
account.read_config_file
p account_info = account.info
portfolio = StockTip::Portfolio.new(default_directory)
portfolio.load_account(account)
unless portfolio.exists?
  puts "I don't see a portfolio in #{default_directory}, let me prompt you "+
    "to create one"
  StockTip::CLI.add_stock(portfolio)
end
portfolio.read_config_file
summary = lambda do
  stocks = portfolio.info
  column_width=14
  columns = %w[symbol shares purchase_price value sell_value current_price]
  header = columns.map { |c| c.to_s.ljust(column_width) }.join('|')
  spacer = "#{"-" * (columns.size * column_width + columns.size)}"
  say spacer
  say "#{header}\n"
  say spacer
  stocks.each { |stock|
    printme = stock.to_s(column_width)
    say "#{printme}\n"
  }
end

StockTip::CLI.main_menu(summary: summary, portfolio: portfolio)


