.SUFFIXES:

ifeq ($(strip $(DEVKITARM)),)
export DEVKITARM := /opt/devkitpro/devkitARM
endif

ifeq ($(strip $(DEVKITPRO)),)
export DEVKITPRO := /opt/devkitpro
endif

include $(DEVKITARM)/ds_rules

TARGET		:=	princess_life_ds
BUILD		:=	build
SOURCES		:=	source
DATA		:=	data
INCLUDES	:=	include

ARCH		:=	-march=armv5te -mtune=arm946e-s -mthumb

CFLAGS		:=	-g -Wall -O2 \
				-ffunction-sections -fdata-sections \
				$(ARCH)

CXXFLAGS	:=	$(CFLAGS) -fno-rtti -fno-exceptions

ASFLAGS		:=	-g $(ARCH)
LDFLAGS		:=	-specs=ds_arm9.specs $(ARCH) \
				-Wl,-Map,$(notdir $(TARGET)).map

LIBS		:=	-lnds9 -lm

LIBDIRS		:=	$(LIBNDS)

# ---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))
# ---------------------------------------------------------------------------------

export VPATH	:=	$(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) \
					$(foreach dir,$(DATA),$(CURDIR)/$(dir))

cfiles		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
cppfiles	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
sfiles		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
binfiles	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.*)))

ofiles		:=	$(addsuffix .o,$(binfiles)) \
					$(cppfiles:.cpp=.o) \
					$(cfiles:.c=.o) \
					$(sfiles:.s=.o)

export DEPSDIR	:=	$(CURDIR)/$(BUILD)

OUTPUT		:=	$(CURDIR)/$(TARGET)
include $(DEVKITARM)/ds_defaults

# ---------------------------------------------------------------------------------
else
# ---------------------------------------------------------------------------------

$(BUILD):
	@mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

all: $(BUILD)

clean:
	@echo cleaning ...
	@rm -fr $(BUILD) $(TARGET).elf $(TARGET).nds

# ---------------------------------------------------------------------------------
endif
