require 'minitest/autorun'

require_relative '../lib/stock_tip/yaml_interface'

describe StockTip::YamlInterface do
  it "checks if your broker information exists already" do
    account = StockTip::YamlInterface.new("./data/empty","test.yaml")
    account.exists?.must_equal(false)
  end
  
  it "creates a new account" do
    account = StockTip::YamlInterface.new("./data/test","test.yaml")
    account.create(account: { :name => "Ameritrade", 
                                  :buy_fee => 999,
                                  :sell_fee => 1002 } )
    account.exists?.must_equal(true)
    account2 = StockTip::YamlInterface.new("./data/test","test.yaml")
    x = account2.read_config_file
    x[:name].must_equal("Ameritrade")
    File.delete(account.config_file)
  end
end
