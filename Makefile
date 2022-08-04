# https://github.com/StarGate01/Full-Stack-Fortran/blob/master/test/makefile
.PHONY: build dirs clean purge

# String operation helpers
null  :=
space := $(null) #
comma := ,
define uniq =
  $(eval seen :=)
  $(foreach _,$1,$(if $(filter $_,${seen}),,$(eval seen += $_)))
  ${seen}
endef

# Path setup
BLDPATH:=$(shell realpath $(BUILD_DIR))
BLDPATHABS:=$(shell realpath $(BLDPATH))
SRCPATH:=$(shell realpath $(SOURCE_DIR))
STAPATH:=static

FILESYSTEMPATH:=$(shell realpath $(FILESYSTEM_DIR))


# Build options
OPT:=-O3
DEBUG:=

# Tools and flags
FC:=emfc.sh
CC:=emcc
WLD:=emcc
AR:=emar
RANLIB:=emranlib
FCFLAGS:=$(DEBUG) $(OPT) -Wall
CCFLAGS:=$(DEBUG) --target=wasm32-unknown-emscripten $(OPT) -c -flto -emit-llvm -m32 -Isrc -Wall
EMSFLAGS:=$(OPT) $(DEBUG) -m32 -Wall -flto
# WLDFLAGS:=-lm --preload-file $(FILESYSTEM_DIR)@/ -s ASSERTIONS=1 -s ALLOW_MEMORY_GROWTH=1 -s EXPORTED_RUNTIME_METHODS=FS,PATH,ccall,cwrap 
WLDFLAGS:=-Wl,-u,atexit -Wl,-u,__cxa_atexit -s ERROR_ON_UNDEFINED_SYMBOLS=1 -lm --preload-file $(FILESYSTEM_DIR)@/ -s ASSERTIONS=1 -s ALLOW_MEMORY_GROWTH=1 -s EXPORTED_RUNTIME_METHODS=FS,PATH -s 'EXPORT_NAME="createModule"'
 # WLDFLAGS:=-Wl,-u,atexit -Wl,-u,__cxa_atexit -s ERROR_ON_UNDEFINED_SYMBOLS=1  -lm --preload-file $(FILESYSTEM_DIR)@/ -s ASSERTIONS=1 -s ALLOW_MEMORY_GROWTH=1 -s EXPORTED_RUNTIME_METHODS=FS,PATH
# WLDFLAGS:=-Wl,-u,atexit -Wl,-u,__cxa_atexit -s WASM=1 -s EXPORTED_RUNTIME_METHODS=ccall,cwrap -s MODULARIZE=1 -s ERROR_ON_UNDEFINED_SYMBOLS=1 -s 'EXPORT_NAME="createModule"' #  -s USE_SDL=2 -s LEGACY_GL_EMULATION=1
ARFLAGS:=cr

# Project config
NAME:=$(PACKAGE_NAME)
# NAME:=assembly
EXPORTS:=mypmmoda_MOD_mainbim
LIBS:=/app/lib/libgfortran.a # /app/lib/liblapack.a /app/lib/librefblas.a
EXPORTSD:=$(EXPORTS:%=___%)
# EXPORTFLAGS:=-s LINKABLE=1 -s EXPORT_ALL=1
EXPORTFLAGS:=-s EXPORTED_FUNCTIONS=$(subst $(space),$(comma),$(strip $(EXPORTSD)))

# Define sources and dependencies
# IOlib
# FSRCS_IOLIB:=$(SRCPATH)/iolib/iolib.f90
# CSRCS_IOLIB:=$(SRCPATH)/iolib/iolib.c
# MOD_IOLIB:=$(CSRCS_IOLIB:$(SRCPATH)/%=$(BLDPATH)/%.bc)
# Project files
FSRCS_TEST:= #$(SRCPATH)/lapack_test/blas0.f90
MOD_TEST:=$(FSRCS_TEST:$(SRCPATH)/%=$(BLDPATH)/%.bc)
FSRCS_USER:=$(SRCPATH)/pyDAMPF.f90 # $(SRCPATH)/test.f90 $(SRCPATH)/lapack_test/test_eigen.f90 $(SRCPATH)/lapack_test/lapack_prb.f90 # $(SRCPATH)/lapack_test/blas3_z_prb.f90 
CSRCS_USER:=
MOD_USER:=
$(info    FSRCS_USER is $(FSRCS_USER))

# Define dependencies
$(FSRCS_USER): $(MOD_IOLIB) $(MOD_TEST)
# Aggregate sources
FSRCS:=$(FSRCS_IOLIB) $(FSRCS_USER) $(FSRCS_TEST)
CSRCS:=$(CSRCS_IOLIB) $(CSRCS_USER)
MODDIRS:=-I$(BLDPATH)
# MODDIRS:=-I$(BLDPATH) -I$(BLDPATH)/iolib -I$(BLDPATH)/lapack_test

# Create file lists
FBCS:=$(FSRCS:$(SRCPATH)/%=$(BLDPATH)/%.bc)
CBCS:=$(CSRCS:$(SRCPATH)/%=$(BLDPATH)/%.bc)
BIN:=$(BLDPATH)/$(NAME).js
ARCHIVE:=$(BLDPATH)/$(NAME).a


# Control targets
# build: clean dirs $(BIN)
# 	cp -f $(STAPATH)/* $(BLDPATH)

# dirs:
# 	cd $(SRCPATH) && find . -type d -exec mkdir -p -- $(BLDPATHABS)/{} \;

# clean:
# 	find $(SRCPATH) -name "*.mod" -type f -delete
# 	$(shell mkdir -p $(BLDPATH))
# 	cd $(BLDPATH) && rm -rf iolib lapack_test *.bc *.ll *.llpre *.mod *.wasm *.html *.js

# purge:
# 	rm -rf $(BLDPATH)


# Compile sources
$(BLDPATH)/%.f90.bc: $(SRCPATH)/%.f90
	$(FC) $(FCFLAGS) $(MODDIRS) -J $(dir $@) -o $@ -c $<
$(BLDPATH)/%.F90.bc: $(SRCPATH)/%.F90
	$(FC) $(FCFLAGS) $(MODDIRS) -J $(dir $@) -o $@ -c $<
$(BLDPATH)/%.f.bc: $(SRCPATH)/%.f
	$(FC) $(FCFLAGS) $(MODDIRS) -J $(dir $@) -o $@ -c $<
$(BLDPATH)/%.c.bc: $(SRCPATH)/%.c
	$(CC) $(CCFLAGS) -o $@ $< 

# Archive objects
$(ARCHIVE): $(CBCS) $(FBCS)
	$(AR) $(ARFLAGS) $@ $^
	$(RANLIB) $@

# Link and wrap in Javascript
$(BIN): $(ARCHIVE) $(LIBS)
	$(WLD) $(EMSFLAGS) $(WLDFLAGS) $(EXPORTFLAGS) -o $@ $^ 

# IMPORTANT: app target must be defined for motivus framework compilation
app: $(BIN)

