require 'capn_proto'

ADDRESSBOOK_SCHEMA = File.expand_path("../addressbook.capnp", __FILE__);

describe CapnProto do
  it "works" do
    imports = []
    parser = CapnProto::SchemaParser.new
    schema = parser.parse_disk_file(
      "addressbook",
      ADDRESSBOOK_SCHEMA,
      imports);

    node_reader = schema.get_proto
  end
end
