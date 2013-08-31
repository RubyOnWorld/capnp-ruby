#include "ruby_capn_proto.h"

namespace ruby_capn_proto {
  class SchemaNodeReader {
  public:
    static void Init();
    static VALUE alloc(VALUE klass);
    static VALUE create(capnp::schema::Node::Reader reader);
    static void free(capnp::schema::Node::Reader* p);
    static capnp::schema::Node::Reader* unwrap(VALUE self);
    static VALUE get_proto(VALUE self);
    static VALUE is_struct(VALUE self);
    static VALUE is_enum(VALUE self);

    static VALUE Class;
  };
}
