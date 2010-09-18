module YDD
  module SerializationHelper

    class Base
      attr_reader :extension

      def initialize(helper)
        @dumper    = helper.dumper
        @loader    = helper.loader
        @extension = helper.extension
      end

      def dump(filename)
        disable_logger
        @dumper.dump(File.new(filename, "w"))
        reenable_logger
      end

      def load(filename, truncate = true)
        disable_logger
        @loader.load(File.new(filename, "r"), truncate)
        reenable_logger
      end

      def disable_logger
        @@old_logger = ActiveRecord::Base.logger
        ActiveRecord::Base.logger = nil
      end

      def reenable_logger
        ActiveRecord::Base.logger = @@old_logger
      end
    end
  
    class Load
      def self.load(io, truncate = true)
        YDD.connection.transaction do
          load_documents(io, truncate)
        end
      end

      def self.truncate_table(table)
        begin
          YDD.connection.execute("TRUNCATE #{SerializationHelper::Utils.quote_table(table)}")
        rescue Exception
          YDD.connection.execute("DELETE FROM #{SerializationHelper::Utils.quote_table(table)}")
        end
      end

      def self.load_table(table, data, truncate = true)
        column_names = data['columns']
        if truncate
          truncate_table(table)
        end
        load_records(table, column_names, data['records'])
        reset_pk_sequence!(table)
      end

      def self.load_records(table, column_names, records)
        if column_names.nil?
          return
        end
        columns = column_names.map{|cn| YDD.connection.columns(table).detect{|c| c.name == cn}}
        quoted_column_names = column_names.map { |column| YDD.connection.quote_column_name(column) }.join(',')
        quoted_table_name = SerializationHelper::Utils.quote_table(table)
        records.each do |record|
          quoted_values = record.zip(columns).map{|c| YDD.connection.quote(c.first, c.last)}.join(',')
          YDD.connection.execute("INSERT INTO #{quoted_table_name} (#{quoted_column_names}) VALUES (#{quoted_values})")
        end
      end

      def self.reset_pk_sequence!(table_name)
        if YDD.connection.respond_to?(:reset_pk_sequence!)
          YDD.connection.reset_pk_sequence!(table_name)
        end
      end    

      
    end

    module Utils

      def self.unhash(hash, keys)
        keys.map { |key| hash[key] }
      end

      def self.unhash_records(records, keys)
        records.each_with_index do |record, index|
          records[index] = unhash(record, keys)
        end

        records
      end

      def self.convert_booleans(records, columns)
        records.each do |record|
          columns.each do |column|
            next if is_boolean(record[column])
            record[column] = (record[column] == 't' or record[column] == '1')
          end
        end
        records
      end

      def self.boolean_columns(table)
        columns = YDD.connection.columns(table).reject { |c| silence_warnings { c.type != :boolean } }
        columns.map { |c| c.name }
      end

      def self.is_boolean(value)
        value.kind_of?(TrueClass) or value.kind_of?(FalseClass)
      end

      def self.quote_table(table)
        YDD.connection.quote_table_name(table)
      end

    end

    class Dump
      def self.before_table(io, table)

      end

      def self.dump(io)
        tables.each do |table|
          before_table(io, table)
          dump_table(io, table)
          after_table(io, table)
        end
      end

      def self.after_table(io, table)

      end

      def self.tables
        YDD.connection.tables.reject { |table| ['schema_info', 'schema_migrations'].include?(table) }
      end

      def self.dump_table(io, table)
        return if table_record_count(table).zero?

        dump_table_columns(io, table)
        dump_table_records(io, table)
      end

      def self.table_column_names(table)
        YDD.connection.columns(table).map { |c| c.name }
      end


      def self.each_table_page(table, records_per_page=1000)
        total_count = table_record_count(table)
        pages = (total_count.to_f / records_per_page).ceil - 1
        id = table_column_names(table).first
        boolean_columns = SerializationHelper::Utils.boolean_columns(table)
        quoted_table_name = SerializationHelper::Utils.quote_table(table)

        (0..pages).to_a.each do |page|
          sql = YDD.connection.add_limit_offset!("SELECT * FROM #{quoted_table_name} ORDER BY #{id}",
                                                                :limit => records_per_page, :offset => records_per_page * page
          )
          records = YDD.connection.select_all(sql)
          records = SerializationHelper::Utils.convert_booleans(records, boolean_columns)
          yield records
        end
      end

      def self.table_record_count(table)
        YDD.connection.select_one("SELECT COUNT(*) FROM #{SerializationHelper::Utils.quote_table(table)}").values.first.to_i
      end

    end

  end
end