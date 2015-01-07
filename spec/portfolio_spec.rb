require 'minitest/autorun'

require_relative '../lib/stock_tip/yaml_interface/portfolio'
require_relative '../lib/stock_tip/yaml_interface/account_info'

describe StockTip::Portfolio do


  it "checks if your broker information exists already" do
    empty_portfolio = StockTip::Portfolio.new("./data/empty")
    empty_portfolio.exists?.must_equal(false)
  end
  
  it "creates a new portfolio" do
    portfolio = StockTip::Portfolio.new("./data/test")
    portfolio.write(info: { :name => "Ameritrade", 
                                  :buy_fee => 999,
                                  :sell_fee => 1002 } )
    portfolio.exists?.must_equal(true)
    account2 = StockTip::Portfolio.new("./data/test")
    account2.read_config_file
    account2.read_config_file[:name].must_equal('Ameritrade')
    File.delete(account2.config_file)
  end

  it "adds multiple entries to the portfolio" do
    account = StockTip::AccountInfo.new("./data/test")
    account.write(info: { :name => "Ameritrade", 
                                  :buy_fee => 999,
                                  :sell_fee => 1002 } )
    portfolio = StockTip::Portfolio.new("./data/test")
    portfolio.load_account(account)
    portfolio.push("MCD",100.00,100,9.99,"2014-9-9") 
    portfolio.push("GE",100.00,100,9.99,"2014-9-9") 
    portfolio.sell_value.must_be_within_delta(11_531_02,1_000_00)
    File.delete(account.config_file)
    File.delete(portfolio.config_file)
  end


  it "adds multiple entries to the portfolio" do
    account = StockTip::AccountInfo.new("./data/test")
    account.write(info: { :name => "Ameritrade", 
                                  :buy_fee => 999,
                                  :sell_fee => 1002 } )
    portfolio = StockTip::Portfolio.new("./data/test")
    portfolio.load_account(account)
    portfolio.push("MCD",100.00,100,9.99,"2014-9-9") 
    portfolio.push("GE",100.00,100,9.99,"2014-9-9") 
    portfolio.info.select {|stock| stock.symbol == "GE"}.size.must_equal(1)
    portfolio.reject!("GE") 
    portfolio.info.select {|stock| stock.symbol == "GE"}.size.must_equal(0)
    portfolio.reject!("MCD")
    File.delete(account.config_file)
    File.delete(portfolio.config_file)
  end

end
