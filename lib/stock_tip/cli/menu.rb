module StockTip

  require 'highline'
  require_relative '../../yfapi/stock_info'
  require_relative '../../yaml_interface'

  module CLI
    TEST = lambda { say "howdy" }
    class Menu
      def initialize(default_directory: nil, input: STDIN, output: STDOUT)
        @stock_info = YFAPI::StockInfo.new()
        @highline= HighLine.new(input,output)
        @default_directory = default_directory
        self.account 
      end

      def account
        @account = StockTip::AccountInfo.new(@default_directory)
        unless @account.has_data?
          highline.say "I don't see an account in #{default_directory}," + 
            " let me prompt you to create one"
          self.create_account(@account)
        end
      end

      def main_menu(list: TEST , summary: TEST, 
                    portfolio: nil, watchlist: nil)
        choices = %w{watchlist portfolio quit}
        quit = false
        while quit == false
          @highline.choose do |menu|
            @highline.say "main menu"
            menu.index        = :letter
            menu.index_suffix = ") "
            menu.prompt       = "choice:"
            menu.choice :watchlist do 
              watch_list(watchlist); 
            end
            menu.choice :portfolio do 
              portfolio(portfolio)
            end
            menu.choice :quit do 
              quit = true 
            end
          end
        end
      end

      def add_stock(portfolio)
        symbol = self.symbol() 
        price_per_share = ask("price per share?")
        buy_fee = @highline.ask("buy fee? [#{portfolio.account_info[:buy_fee]}]")
        p buy_fee
        p buy_fee.to_s.respond_to?(:to_f)
        buy_fee = portfolio.account_info[:buy_fee]  unless (buy_fee.to_f > 0.0)
        p buy_fee
        shares = @highline.ask("number of shares?")
        purchase_date = self.date
        portfolio.push(symbol,
                            price_per_share.to_f,
                            shares.to_i,
                            buy_fee.to_f,
                            purchase_date)
      end

      def date
        purchase_date = @highline.ask("purchase date?")
        while purchase_date !~ /\d{4}-\d{1,2}-\d{1,2}/
          @highline.say "purchase date should be formatted like '2014-1-1'"
          purchase_date = @highline.ask("purchase date?")
        end
        purchase_date
      end

      def symbol()
        try_this_symbol = nil
        while(try_this_symbol == nil)
          symbol = @highline.ask("stock symbol?")
          if symbol == nil || @stock_info.price(symbol) == nil
            @highline.say "symbol #{symbol} not found. Reprompting:" 
            try_this_symbol = nil
          else
            return symbol
          end
          symbol = nil
        end
      end

      def create_account(account)
        account_info = {}
        account_info[:broker]   = @highline.ask("broker name?")
        account_info[:sell_fee] = @highline.ask("sell fee?")
        account_info[:buy_fee]  = @highline.ask("buy fee?")
        @highline.say "creating account"
        account.write(info: account_info)
      end

      def portfolio(portfolio)
        action = ""
        until (action =~ /quit|q/i )
          @highline.say "your portfolio"
          stocks = portfolio.info
          column_width=14
          columns = %w[symbol shares price/share broker_fee total_price sell_value 
                 current_price ]
          header = columns.map { |c| c.to_s.ljust(column_width) }.join('|')
          spacer = "#{"-" * (columns.size * column_width + columns.size)}"
          @highline.say spacer
          @highline.say "#{header}\n"
          @highline.say spacer
          stocks.each do |stock|
            printme = stock.to_s(column_width)
            @highline.say "#{printme}\n"
          end
          @highline.say "actions:"
          @highline.say "  [a] to add a stock to the portfolio"
          @highline.say "  [d] to delete a symbol"
          @highline.say "  [q] or [quit] to quit to previous menu"
          @highline.say "  [enter] to refresh"
          action = @highline.ask "action?"
          self.add_stock(portfolio) if action == "a"
          portfolio.reject!(self.symbol()) if action == "d"
        end
      end

      def watch_list(watchlist)
        symbol = ""
        watchlist.read_config_file
        until (symbol =~ /quit|q/i )
          @highline.say watchlist.to_s
          @highline.say "actions:"
          @highline.say "  [a symbol] to add a symbol to the watchlist"
          @highline.say "  [d symbol] to delete a symbol"
          @highline.say "  [r] to refresh"
          @highline.say "  [q] or [quit]] to quit to previous menu"
          symbol = ask "actions?"
          command,option = symbol.split(/\s+/)
          edit_fields(watchlist) if command == "f"
          watchlist.add(option.to_s) if command == "a"
          watchlist.delete(option.to_s) if command == "d"
          next if command == "r"
        end
      end

      def edit_fields(watchlist)
        wlf = watchlist.wlf
        p wlf.categories
      end

    end
  end
end
