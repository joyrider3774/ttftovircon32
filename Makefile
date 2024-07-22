DEBUG=0
SRC_DIR = src
OBJ_DIR = obj
EXE=ttftovircon

SRC=$(wildcard $(SRC_DIR)/*.c)
OBJS=$(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)


CC ?= gcc
SDL2CONFIG ?= sdl2-config
DEFINES ?= 
DESTDIR ?=
PREFIX ?= /usr
OPT_LEVEL ?= -O2
CFLAGS ?= -Wall -Wextra  `$(SDL2CONFIG) --cflags`
LDFLAGS ?=

#it was only way i could get it to link against static libs under msys2 / mingw
ifeq ($(OS),Windows_NT)
LDLIBS ?= -static -static-libgcc -static-libstdc++  `$(SDL2CONFIG) --static-libs` `pkg-config -libs -static SDL2_image SDL2_ttf` "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libSDL2_image.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libSDL2_image.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libSDL2_ttf.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libjpeg.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libpng16.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libharfbuzz.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libfreetype.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libjxl.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libavif.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libbz2.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libgraphite2.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libbrotlidec.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libbrotlicommon.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libaom.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libdav1d.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libhwy.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libwinpthread.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/librav1e.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libtiff.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libsharpyuv.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libwebp.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libstdc++.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libdeflate.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libjpeg.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libjbig.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/liblzma.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libyuv.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libwebpdemux.a" "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libzstd.a"  "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libLerc.a" 
ifeq ($(MSYSTEM_PREFIX),/mingw64)
LDLIBS += "$(PKG_CONFIG_SYSTEM_LIBRARY_PATH)/libSvtAv1Enc.a"
endif
else
LDLIBS ?= `$(SDL2CONFIG) --libs` `pkgconf -libs SDL2_image SDL2_ttf`
endif
DEFINESADD = 
FINALDEFINES = $(DEFINES) $(DEFINESADD)

ifeq ($(OS),Windows_NT)
LDLIBS += -mconsole
endif

ifeq ($(DEBUG), 1)
CFLAGS += -g
LDFLAGS += -g
OPT_LEVEL =
endif

.PHONY: all clean

all: $(EXE)

$(EXE): $(OBJS)
	$(CC) $(OPT_LEVEL) $(LDFLAGS) $(TARGET_ARCH) $(FINALDEFINES) $^ $(LDLIBS) -o $@ 

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)  
	$(CC) $(OPT_LEVEL) $(CFLAGS) $(CXXFLAGS) $(FINALDEFINES) -c $< -o $@

$(OBJ_DIR): 
	mkdir -p $@

clean:
	$(RM) -rv *~ $(OBJ_DIR) $(EXE)