module StockTip
  class AccountInfo
    
    require 'yaml'

    ACCOUNT_FILE="account.yaml"
    def initialize(directory)
      @config_file = "#{directory}/#{ACCOUNT_FILE}"
      @account_info = nil
    end

    attr_reader :config_file

    def account_exists?
      File.exists?(@config_file)
    end

    def read_config_file
      unless account_exists?
        raise "file #{config_file} nonexistent.  use create_account to create"
      end
      @account_info = YAML.load_file(@config_file)
    end

    def create_account(account: { :name => "Ameritrade", 
                                  :buy_fee => 999,
                                  :sell_fee => 1002 } )
      File.open(@config_file, "w") {|f| f.write account.to_yaml } 
    end
  end
end
