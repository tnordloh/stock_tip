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
        @watchlist = StockTip::WatchList.new(default_directory)
        @exit = false
      end


      def portfolio_to_s
        action = ""
        load_portfolio if @portfolio == nil
        unless @portfolio.has_data?
          @highline.say "there are no stocks in your portfolio"+
            " (#{@default_directory})," + 
            " let me prompt you to create one"
          self.add_stock_to_portfolio()
        end
        @highline.say "your portfolio"
        stocks = @portfolio.info
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
      end

      def delete_stock_from_portfolio
          @portfolio.reject!(self.symbol())
      end

      def portfolio
        action = ""
        choices = %w{add_stock_to_portfolio delete_stock_from_portfolio}
        quit = false
        while quit == false
          portfolio_to_s
          @highline.choose do |menu|
            @highline.say "portfolio actions:"
            menu.index = :letter
            menu.index_suffix = ") "
            menu.prompt       = "choice:"
            choices.each do |item|
              menu.choice item do 
                self.send(item)
              end
            end
            menu.choice :quit do
              quit = true
            end
            menu.choice :exit do
              exit
            end
          end
        end
      end

      def main_menu
        load_account if @account = nil
        choices = %w{watchlist portfolio}
        quit = false
        while quit == false
          @highline.choose do |menu|
            @highline.say "main menu  \n"
            menu.index        = :letter
            menu.index_suffix = ") "
            menu.prompt       = "choice:"
            choices.each do |item|  
              menu.choice item do 
                self.send(item)
              end
            end
            menu.choice :exit do
              exit
            end
          end
        end
      end

      def quit
        @exit = true
      end

      def add_stock_to_portfolio()
        load_account if @account == nil
        buy_fee = @highline.ask "buy fee? [#{@account.buy_fee}]" 
        buy_fee = @account.buy_fee if  (buy_fee == "")
        symbol = self.symbol() 
        price_per_share = @highline.ask("price per share?")
        p @account.info
        shares = @highline.ask("number of shares?")
        purchase_date = self.date
        @portfolio.push(symbol,
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
          stock = YFAPI::Stock.new(symbol)
          unless stock.exist?
            @highline.say "symbol #{symbol} not found. Reprompting:" 
            try_this_symbol = nil
          else
            return symbol
          end
          symbol = nil
        end
      end

      def create_account()
        account_info = {}
        @highline.say "account info hasn't been populated, let me prompt you for it'"
        account_info[:broker]   = @highline.ask("broker name?")
        account_info[:sell_fee] = @highline.ask("sell fee?")
        account_info[:buy_fee]  = @highline.ask("buy fee?")
        @highline.say "creating account"
        account_info
      end


      def watchlist()
        @watchlist.read_config_file
        unless @watchlist.has_data?
          @highline.say "no watchlist found. Prompting you to add the first item"
          @watchlist.push(self.symbol())
        end
        action = ""
        until (action =~ /quit|q/i )
          @highline.say @watchlist.to_s
          @highline.say "actions:"
          @highline.say "  [a symbol] to add a symbol to the watchlist"
          @highline.say "  [d symbol] to delete a symbol"
          @highline.say "  [r] to refresh"
          @highline.say "  [q] or [quit]] to quit to previous menu"
          action = ask "actions?"
          command,option = action.split(/\s+/)
          @watchlist.push(option.to_s) if command == "a"
          @watchlist.delete(option.to_s) if command == "d"
          next if command == "r"
        end
      end

      private

      def load_account
        @account = StockTip::AccountInfo.new(@default_directory)
        unless @account.has_data?
          @highline.say "I don't see an account in #{@default_directory}," + 
            " let me prompt you to create one"
          @account.write(info = self.create_account)
        end
        load_portfolio
        @portfolio.load_account(@account)
      end

      def load_portfolio
        @portfolio = StockTip::Portfolio.new(@default_directory)
      end

    end
  end
end
