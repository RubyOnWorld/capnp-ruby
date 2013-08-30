require 'mkmf'

CONFIG['CXX'] = "/Users/charlesstrahan/clang-3.2/bin/clang++"
CONFIG['CXXFLAGS'] += " -std=c++11 -stdlib=libc++"

if enable_config('debug')
  $CFLAGS += " -O0 -ggdb3"
end

$LDFLAGS += " -lcapnpc"
$LDFLAGS += " -lcapnp"
$LDFLAGS += " -lkj"

HEADER_DIRS = ["/usr/local/include"]
LIB_DIRS    = ["/usr/local/lib"]

create_makefile('ruby_capn_proto/init')


# HACK ATTACK
def inreplace(path, search, replace)
  contents = File.read(path)
  contents.gsub!(search, replace)
  File.open(path, "w") do |f|
    f.write(contents)
  end
end

inreplace("Makefile", "V = 0", "V = 1")
inreplace("Makefile", "-O3", "-O0")
inreplace("Makefile", "ECHO = $(ECHO1:0=@echo)", "ECHO = @echo")