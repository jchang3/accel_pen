#!/bin/sh
#
# This file was automatically generated.
#
# It can be overwritten by nios2-flash-programmer-generate or nios2-flash-programmer-gui.
#

#
# Converting ELF File: C:\Users\jchang3\Documents\ECE492\test\software\accelerometer_pen50sflash\accelerometer_pen50sflash.elf to: "..\flash/accelerometer_pen50sflash_generic_tristate_controller_0.flash"
#
elf2flash --input="C:/Users/jchang3/Documents/ECE492/test/software/accelerometer_pen50sflash/accelerometer_pen50sflash.elf" --output="../flash/accelerometer_pen50sflash_generic_tristate_controller_0.flash" --boot="nios2eds/components/altera_nios2/boot_loader_cfi.srec" --base=0x1400000 --end=0x1800000 --reset=0x1400000 

#
# Programming File: "..\flash/accelerometer_pen50sflash_generic_tristate_controller_0.flash" To Device: generic_tristate_controller_0
#
nios2-flash-programmer "../flash/accelerometer_pen50sflash_generic_tristate_controller_0.flash" --base=0x1400000 --sidp=0x1909458 --id=0x0 --timestamp=1396679091 --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-0]' --program 

