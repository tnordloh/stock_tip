require 'minitest/autorun'

require_relative '../lib/stock_tip/cli/menu'

describe StockTip::CLI do

  before do
    @input = StringIO.new
    @output = StringIO.new
    @terminal = HighLine.new(@input,@output)
    @cli = StockTip::CLI::Menu.new(input: @input, output: @output)
  end

  it "can prompt for a date" do
    @input << "2014-12-01\n"
    @input.rewind
    @cli.date.must_equal("2014-12-01")
    @input.truncate(@input.rewind)
    @input << "not a date\n2015-1-1"
    @input.rewind
    @cli.date.must_equal("2015-1-1")
  end

  it "can recognize a valid stock symbol" do
    @input << "GE\n"
    @input.rewind
    @cli.symbol.must_equal("GE")
  end

  it "can recognize an invalid stock symbol" do
    @input << "not a symbol\nGE\n"
    @input.rewind
    @cli.symbol.must_equal("GE")
  end

  it "can create an account" do
    DummyAccount = Struct.new(:x) do
      def write(info: nil)
        if info[:broker] == "test" && 
           info[:sell_fee] == "test2" &&
           info[:buy_fee] == "test3"
          return true
        else
          return false
        end
      end
    end
    @input << "test\ntest2\ntest3\n"
    @input.rewind
    @cli.create_account(DummyAccount.new(1)).must_equal(true)
  end


  after do
    @input.truncate(@input.rewind)
  end

end
