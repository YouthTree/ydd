module YDD
  class SchemaManager

    def self.dump(path)
      File.open(path, "w") do |file|
        ActiveRecord::SchemaDumper.dump(YDD.connection, file)
      end
    end

    def self.load(path)
      Kernel.load path if File.exists?(path)
    end

  end
end