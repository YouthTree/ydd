module YDD
  module YamlDB
    module Helper
      def self.loader
        YamlDB::Load 
      end

      def self.dumper
        YamlDB::Dump
      end

      def self.extension
        "yml"
      end
    end


    module Utils
      def self.chunk_records(records)
        yaml = [ records ].to_yaml
        yaml.sub!("--- \n", "")
        yaml.sub!('- - -', '  - -')
        yaml
      end

    end

    class Dump < SerializationHelper::Dump
 
      def self.dump_table_columns(io, table)
        io.write("\n")
        io.write({ table => { 'columns' => table_column_names(table) } }.to_yaml)
      end

      def self.dump_table_records(io, table)
        table_record_header(io)

        column_names = table_column_names(table)

        each_table_page(table) do |records|
          rows = SerializationHelper::Utils.unhash_records(records, column_names)
          io.write(YamlDB::Utils.chunk_records(records))
        end
      end

      def self.table_record_header(io)
        io.write("  records: \n")
      end

    end

    class Load < SerializationHelper::Load
      def self.load_documents(io, truncate = true) 
          YAML.load_documents(io) do |ydoc|
            ydoc.keys.each do |table_name|
              next if ydoc[table_name].nil?
              load_table(table_name, ydoc[table_name], truncate)
            end
          end
      end
    end

  end
end