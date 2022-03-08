# 6502-macroprocessor

## Components
| Function               | Component name        | Kicad name | Data sheet                                                 | Number | Comments |
| ---------------------- | --------------------- | ---------- | ---------------------------------------------------------- | ------ | -------- |
| Basic logic            |                       |            |                                                            |        |          |
| NAND Quad 2-in         | SN74AC00N             | 74HC00     | https://www.ti.com/lit/gpn/sn74hc00                        | 40     |          |
| OR Quad 2-in           | SN74HC32N             | 74LS32     | http://www.ti.com/lit/gpn/sn74LS32                         | 50     |          |
| XOR Quad 2-in          | SN74AC86N             | 74HC86     | http://www.ti.com/lit/gpn/sn74HC86                         | 20     |          |
| NOR Quad 2-in          | CD74AC02N             | 74HC02     | http://www.ti.com/lit/gpn/sn74hc02                         | 5      |          |
| 4-bit fulladder        | CD74HC283E            | 74LS283    | http://www.ti.com/lit/gpn/sn74LS283                        | 10     |          |
|                        |                       |            |                                                            |        |          |
| Drivers                |                       |            |                                                            |        |          |
| 8-bit buffer           | SN74HC541N            | 74HCT541   | http://www.ti.com/lit/gpn/sn74HCT541                       | 10     |          |
| Inverting 8-bit buffer | SN74HC540N            | 74LS540    | http://www.ti.com/lit/gpn/sn74LS540                        | 5      |          |
| 4-bit analogue switch  | DG211BDJ-E3           | Missing    | https://www.farnell.com/datasheets/2614529.pdf             | 4      |          |
|                        |                       |            |                                                            |        |          |
| Registers              |                       |            |                                                            |        |          |
| 8-bit D-latch          | CD74HCT573E           | 74LS573    | https://www.ndr-nkc.de/download/datenbl/74ls573.pdf        | 30     |          |
| 8-bit shift register   | CD74HC299E            | 74LS299    | http://www.ti.com/lit/gpn/sn74LS299                        | 5      |          |
|                        |                       |            |                                                            |        |          |
| ROMS                   |                       |            |                                                            |        |          |
| 1MB 17x8 bit ROM       | SST39SF010A-70-4C-PHE | SST39SF010 | http://ww1.microchip.com/downloads/en/DeviceDoc/25022B.pdf | 4      |          |
| 2MB 18x8 bit ROM       | SST39SF020A-70-4C-PHE | SST39SF020 | http://ww1.microchip.com/downloads/en/DeviceDoc/25022B.pdf | 14     |          |
|                        |                       |            |                                                            |        |          |
	
