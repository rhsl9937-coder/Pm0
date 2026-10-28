TARGET		:=	princess_life_ds
BUILD		:=	build
SOURCES		:=	source
INCLUDES	:=	include

.SUFFIXES:

ifeq ($(strip $(DEVKITARM)),)
export DEVKITARM := /opt/devkitpro/devkitARM
endif

include $(DEVKITARM)/ds_rules

ARCH		:=	-march=armv5te -mtune=arm946e-s -mthumb
CFLAGS		:=	-g -Wall -O2 -ffunction-sections -fdata-sections $(ARCH)
CXXFLAGS	:=	$(CFLAGS) -fno-rtti -fno-exceptions
ASFLAGS		:=	-g $(ARCH)
LDFLAGS		:=	-specs=ds_arm9.specs $(ARCH) -Wl,-Map,$(notdir $(TARGET)).map

LIBS		:=	-lnds9 -lm

export VPATH	:=	$(CURDIR)/source
cfiles		:=	$(notdir $(wildcard source/*.c))
ofiles		:=	$(cfiles:.c=.o)

export DEPSDIR	:=	$(CURDIR)/$(BUILD)
OUTPUT		:=	$(CURDIR)/$(TARGET)

all: $(BUILD)
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile $(TARGET).nds

$(BUILD):
	@mkdir -p $@

ifeq ($(BUILD),$(notdir $(CURDIR)))
include $(DEVKITARM)/ds_defaults
else
clean:
	@echo cleaning ...
	@rm -fr $(BUILD) $(TARGET).elf $(TARGET).nds
endif
