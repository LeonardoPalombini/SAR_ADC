# SAR_ADC

PIN CONNECTIONS
JA
  -G13 to capacitor C pin 1
  -B11 to capacitor C/2 pin 1
  -A11 to capacitor C/4 pin 1
  -D12 to capacitor C/8 pin 1
  -D13 to first capacitor C/16 pin 1
  -B18 to second capacitor C/16 pin 1
  -A18 common to all capacitors pin 2

JB
  -E15 result bit 0
  -E16 result bit 1
  -D15 result bit 2
  -C15 result bit 3
  -J17 result bit 4

JC
  -U12 to GROUND (comp P)
  -V12 common to all capacitors pin 2 (comp N)

JD
  -D4 to external sample switch/MOS


HW SUGGESTIONS
For a correct behaviour, suggested C = 500 pF using a clock frequency F = 1 MHz. Upper limit C = 1 nF.
