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
LDLIBS ?= `$(SDL2CONFIG) --libs` -lSDL2_image -lSDL2_ttf

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