SRC = main.asm
OUTPUT_NAME = main

AS = avra 
ASFLAGS =  
PROG = avrdude
PROGFLAGS = -pm48 -b115200 -cavr910 -P/dev/ttyUSB0 -x devcode=0x31

all: assembler

assembler:
	$(AS) $(ASFLAGS) $(SRC)

flash:
	$(PROG) $(PROGFLAGS) -Uflash:w:$(OUTPUT_NAME).hex

eeprom:
	$(PROG) $(PROGFLAGS) -Ueeprom:w:$(OUTPUT_NAME).eep.hex

clean:
	rm -f $(OUTPUT_NAME).cof
	rm -f $(OUTPUT_NAME).hex
	rm -f $(OUTPUT_NAME).eep.hex
	rm -f $(OUTPUT_NAME).obj
