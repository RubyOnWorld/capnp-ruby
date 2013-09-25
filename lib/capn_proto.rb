require 'capn_proto/capn_proto'
require 'capn_proto/version'

module CapnProto
  ListNestedNodeReader.class_eval do
    include Enumerable
    def each
      return to_enum(:each) unless block_given?
      (0...size).each do |n|
        yield self[n]
      end
    end
  end

  DynamicListReader.class_eval do
    include Enumerable
    def each
      return to_enum(:each) unless block_given?
      (0...size).each do |n|
        yield self[n]
      end
    end
  end

  DynamicStructReader.class_eval do
    def method_missing(name, *args, &block)
      self[name.to_s, *args, &block]
    end
  end

  module SchemaLoader
    def schema_parser
      @schema_parser
    end

    def load_schema(file_name, imports=[])
      display_name = self.name

      @schema_parser ||= CapnProto::SchemaParser.new

      load_schema_rec = Proc.new do |schema, mod|
        node = schema.get_proto
        nested_nodes = node.nested_nodes

        if node.struct?
          struct_schema = schema.as_struct
          mod.instance_variable_set(:@schema, struct_schema)
          mod.extend(Struct)
        end

        nested_nodes.each do |nested_node|
          nested_mod = mod.const_set(nested_node.name, Module.new)
          nested_schema = schema.get_nested(nested_node.name)
          load_schema_rec.call(nested_schema, nested_mod)
        end
      end

      schema = @schema_parser.parse_disk_file(
        display_name,
        file_name,
        imports);

      load_schema_rec.call(schema, self)
    end

    module Struct
      def schema
        @schema
      end

      def read_from(io)
        reader = StreamFdMessageReader.new(io)
        reader.get_root(self)
      end

      def read_packed_from(io)
        raise 'not implemented'
      end

      def new_message(file)
        raise 'not implemented'
      end
    end
  end
end
