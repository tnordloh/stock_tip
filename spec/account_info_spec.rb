require 'minitest/autorun'

require_relative '../lib/account_info/account_info'

describe StockTip::AccountInfo do
  it "checks if your broker information exists already" do
    account = StockTip::AccountInfo.new("./data/empty")
    account.account_exists?.must_equal(false)
  end
  
  it "creates a new account" do
    account = StockTip::AccountInfo.new("./data/test")
    account.create_account(account: { :name => "Ameritrade", 
                                  :buy_fee => 999,
                                  :sell_fee => 1002 } )
    account.account_exists?.must_equal(true)
    account2 = StockTip::AccountInfo.new("./data/test")
    account2.read_config_file
    p account2.read_config_file
    File.delete(account.config_file)
  end
end
