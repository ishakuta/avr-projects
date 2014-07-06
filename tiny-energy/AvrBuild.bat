@ECHO OFF
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "G:\tiny\labels.tmp" -fI -W+ie -C V2 -o "G:\tiny\tiny.hex" -d "G:\tiny\tiny.obj" -e "G:\tiny\tiny.eep" -m "G:\tiny\tiny.map" "G:\tiny\tiny.asm"
