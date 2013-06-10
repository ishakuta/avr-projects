@ECHO OFF
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "F:\tiny\labels.tmp" -fI -W+ie -C V2 -o "F:\tiny\tiny.hex" -d "F:\tiny\tiny.obj" -e "F:\tiny\tiny.eep" -m "F:\tiny\tiny.map" "F:\tiny\tiny.asm"
