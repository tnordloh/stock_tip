require 'minitest/autorun'

require_relative '../lib/stock_tip/yaml_interface/portfolio'

describe StockTip::Portfolio do

  let(:portfolio) { StockTip::Portfolio.new("./data/test") }

  it "checks if your broker information exists already" do
    account = StockTip::Portfolio.new("./data/empty")
    account.exists?.must_equal(false)
  end
  
  it "creates a new portfolio" do
    portfolio.create(account: { :name => "Ameritrade", 
                                  :buy_fee => 999,
                                  :sell_fee => 1002 } )
    portfolio.exists?.must_equal(true)
    account2 = StockTip::Portfolio.new("./data/test")
    account2.read_config_file
    account2.read_config_file[:name].must_equal('Ameritrade')
    File.delete(account.config_file)
  end

  it "adds multiple entries to the portfolio" do
    portfolio.add_account("MCD",100.00,100,9.99,"2014-9-9") 
  end


end
