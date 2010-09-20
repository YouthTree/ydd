require 'thor'
require 'ruby-debug'

module YDD
  class Application < Thor
    include Thor::Actions
    
    method_options :env => :string, :force => :boolean,
                   :skip_schema => :boolean, :skip_data => :boolean,
                   :tables => :string
    
    desc "dump DUMP_DIR [APP_DIR='.'] [OPTIONS]", "Dumps the database contents and schema."
    def dump(dump_dir, app_dir = ".")
      setup! dump_dir, app_dir, :dump => true
      say "Starting dump..."
      YDD.dump @dump_dir
    end
    
    desc "load DUMP_DIR [APP_DIR='.'] [OPTIONS]", "Loads the database contents and schema."
    def load(dump_dir, app_dir = ".")
      setup! dump_dir, app_dir
      say "Starting load..."
      YDD.load @dump_dir
    end
    
    protected
    
    def setup_directories!(dump_dir, app_dir, extra = {})
      @dump_dir  = File.expand_path(dump_dir)
      @app_dir   = File.expand_path(app_dir)
      @db_config = File.join(@app_dir, "config", "database.yml")
      if !File.directory?(@app_dir)
        die "The given application directory, #{@app_dir}, does not exist."
      elsif !File.exist?(@db_config)
        die "#{@db_config} does not exist."
      elsif YDD.configuration_from(@db_config).blank?
        die "Unable to find database configuration for #{YDD.env}."
      elsif extra[:dump] && !Dir[File.join(@dump_dir, "**", "*")].empty? && !options.force?
        die "The given dump dir, #{@dump_dir}, is not empty."
      end
    end
    
    def setup!(dump_dir, app_dir, extra = {})
      YDD.env         = options.env if options.env.present?
      YDD.tables      = options.tables if options.tables.present?
      YDD.skip_data   = options.skip_data?
      YDD.skip_schema = options.skip_schema?
      setup_directories!    dump_dir, app_dir, extra
      connect_to_database!
    end
    
    def connect_to_database!
      YDD.connect_from @db_config
    end
    
    def die(error, code = 1)
      say error
      exit code
    end
    
  end

end