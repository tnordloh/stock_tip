module StockTip
  require_relative './yaml_interface'
  class AccountInfo < StockTip::YamlInterface
    
    ACCOUNT_FILE="account.yaml"

    def initialize(directory)
      super(directory,ACCOUNT_FILE)
      self.read_config_file
    end

  end
end
