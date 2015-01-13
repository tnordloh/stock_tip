require 'minitest/autorun'

require_relative '../lib/stock_tip/yaml_interface/account_info'

describe StockTip::AccountInfo do
  it "creates a new account" do
    account = StockTip::AccountInfo.new("./data/test")
    account.write(info: { :name => "Ameritrade", 
                                  :buy_fee => 999,
                                  :sell_fee => 1002 } )
    account.has_data?.must_equal(true)
    account2 = StockTip::AccountInfo.new("./data/test")
    account2.read_config_file
    p account2.read_config_file
    File.delete(account.config_file)
  end
end
