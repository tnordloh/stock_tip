module StockTip
  class YamlInterface
    
    require 'yaml'

    def initialize(directory,file)
      @config_file = "#{directory}/#{file}"
      @account_info = nil
    end

    attr_reader :config_file

    def exists?
      File.exists?(@config_file)
    end

    def read_config_file
      unless exists?
        raise "file #{config_file} nonexistent.  use create_account to create"
      end
      @account_info = YAML.load_file(@config_file)
    end

    def create(account: { :test => "test_value" } )
      File.open(@config_file, "w") {|f| f.write account.to_yaml } 
    end

  end
end
