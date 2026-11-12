# MinGW-w64 build (native MSYS2/MinGW or cross-compiling from Linux).
# The official build uses the Visual Studio solution; this is an alternative.
#
#   make                                  # native MinGW
#   make CROSS=x86_64-w64-mingw32-        # cross-compile from Linux
#
# Requires a toolchain with std::thread support (the posix threading variant,
# e.g. x86_64-w64-mingw32-g++-posix on Debian/Ubuntu).

CROSS   ?=
CXX     := $(CROSS)g++
WINDRES := $(CROSS)windres

BUILD   ?= build
TARGET  := $(BUILD)/rbxfpsunlocker.exe

CXXFLAGS ?= -O2
CXXFLAGS += -std=c++20 -D_MBCS
LDFLAGS  += -static -mwindows
LDLIBS   := -lwininet -lpsapi -lshlwapi -lshell32 -lole32 -luuid

SRCS := $(wildcard Source/*.cpp)
OBJS := $(patsubst Source/%.cpp,$(BUILD)/%.o,$(SRCS)) $(BUILD)/resource.o

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(LDFLAGS) $^ -o $@ $(LDLIBS)

$(BUILD)/%.o: Source/%.cpp $(wildcard Source/*.h Source/*.hpp) | $(BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD)/resource.o: Source/rbxfpsunlocker.rc Source/resource.h icon.ico | $(BUILD)
	cd Source && $(WINDRES) rbxfpsunlocker.rc -O coff -o $(abspath $@)

$(BUILD):
	mkdir -p $@

clean:
	rm -rf $(BUILD)

.PHONY: all clean
