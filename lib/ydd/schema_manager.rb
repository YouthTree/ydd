module YDD
  class SchemaManager
    
    def self.save_into(path)
      File.open(path, "w") do |file|
        ActiveRecord::SchemaDumper.dump(YDD.connection, file)
      end
    end
    
    def self.load_from(path)
      load path if File.exists?(path)
    end
    
  end
end