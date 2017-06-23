# Compiler and shell
CC         = g++
SHELL      = /bin/bash
RM         = rm -f

# Extensions
SRCEXT     = cpp
HDREXT     = h
OBJEXT     = o
LIBEXT     = so

# Directories
PWD        = $(shell pwd)
SRCDIR     = src
LIBSRCDIR  = lib
HDRDIR     = include
OBJDIR     = build
BINDIR     = bin

# Where the output is
OUTPUT     = $(OBJDIR)/*.$(OBJEXT) $(BINDIR)/*

# ROOT
ROOTCFLAGS     = $(shell root-config --cflags)
ROOTLIBS       = $(shell root-config --libs)
ROOTLIBDIR     = $(shell root-config --libdir)
ROOTLIBFLAGS   = -L$(ROOTLIBDIR) -Wl,--as-needed $(ROOTLIBS) $(EXTRA_ROOTLIBS) -Wl,-rpath,$(ROOTLIBDIR)

# Submodules
COMMONDIR   = common
COMCXXFLAGS = $(shell make -sC $(COMMONDIR) cflags)
COMLIBS     = $(shell make -sC $(COMMONDIR) libs)
COMLIBDIR   = $(shell make -sC $(COMMONDIR) libdir)
COMLIBFLAGS = -L$(COMLIBDIR) -Wl,--as-needed $(COMLIBS) -Wl,-rpath,$(COMLIBDIR)

SUBMODULES = $(COMMONDIR)

# Get files and make list of objects and libraries
BINSRCS   := $(shell find $(SRCDIR) -name '*.$(SRCEXT)')
HDRS      := $(shell find $(HDRDIR) -name '*.$(HDREXT)')
BINS      := $(patsubst $(SRCDIR)/%.$(SRCEXT), $(BINDIR)/%, $(BINSRCS))

# Compiler flags
CXXFLAGS          = -Wall -fPIC -I$(HDRDIR) $(COMCXXFLAGS) $(ROOTCFLAGS) --std=c++1y
LIBFLAGS          = -Wl,--no-undefined -Wl,--no-allow-shlib-undefined  -Wl,--as-needed -lboost_program_options $(COMLIBFLAGS) $(ROOTLIBFLAGS)

.PHONY: all $(SUBMODULES) clean

all : $(BINS)
$(SUBMODULES) :
	make -C $@
# Build binaries
$(BINDIR)/% : $(OBJDIR)/%.$(OBJEXT) $(LIBS) | $(BINDIR) $(SUBMODULES)
	@echo "Linking $@"
	@$(CC) $< -o $@ $(LIBPREFIX) $(LIBFLAGS)
# Build objects
$(OBJDIR)/%.$(OBJEXT) : $(SRCDIR)/%.$(SRCEXT) $(HDRS) | $(OBJDIR)
	@echo "Compiling $@"
	@$(CC) -c $< -o $@ $(CXXFLAGS)
# Make directories
$(BINDIR) $(LIBDIR) $(OBJDIR) :
	mkdir -p $@
# Remove all the output
clean :
	$(RM) $(OUTPUT)
	make -C $(COMMONDIR) clean
