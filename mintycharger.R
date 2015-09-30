#' mintycharger.R
#' Some simple calculations for the MintyCharger 9V.
#' 
#' @author Nathan Campos <nathanpc@dreamintech.net>

rm(list = ls(all = TRUE))  # Clear the workspace.

#' The maximum input voltage to the ADC.
#' 
#' @param r1 R1 in the divider network.
#' @param r2 R2 in the divider network.
#' @param vref The voltage reference of the ADC.
#' @return Maximum input voltage in Volts.
adc_max_input <- function (r1, r2, vref = 5) {
  vin = vref / (r2 / (r1 + r2))

  return(round(vin, 2))
}

#' Determines the ADC resolution.
#' 
#' @param vmax Maximum input voltage.
#' @param bits Number of bits of the ADC.
#' @return ADC resolution in Volts.
adc_resolution <- function (vmax, bits = 10) {
  res = vmax / (2 ^ bits)

  return(round(res, 4))
}

#' Determines the ADC reading value.
#' 
#' @param vin Input voltage.
#' @param vmax Maximum input voltage.
#' @param Number of bits of the ADC.
#' @return ADC reading value.
adc_reading <- function (vin, vmax, bits = 10) {
  reading = (vin * (2 ^ bits)) / vmax
  
  return(round(reading))
}

#' Prints one ADC reading.
#' 
#' @param vin Input voltage.
print_adc_reading <- function (vin) {
  reading = adc_reading(vin, max_input)
  cat(sprintf("%.2fV = %d\n", vin, reading))
}

#' Prints a list of ADC readings according to the number of cells in the battery.
#' 
#' @param cells Number of NiMH cells in the battery.
print_adc_readings <- function (cells) {
  cat(sprintf("\nADC Readings for a %.1fV Battery:\n", cells * 1.2))

  for (v in seq(cells, cells * 1.5, 0.1)) {
    print_adc_reading(v)
  }
}

#' Determines the PR2 value for a desired frequency based on the Fosc.
#' 
#' @param f Desired frequency.
#' @param fosc Main oscillator frequency.
#' @return PR2 value.
pwm_pr2 <- function (f, fosc = 4000000) {
  tisc = 1 / (fosc / 4)
  us = tisc * (1 / f) * 10^12
  
  return(us - 1)
}

pwm_duty_reg <- function (pr2, duty_cycle) {
  period = (pr2 + 1) * duty_cycle
  on = period / 0.25
  bits = intToBits(on)

  dc1b = sprintf("0b%d%d", as.integer(bits[2]),
                           as.integer(bits[1]))
  ccpr1l = sprintf("0b%d%d%d%d%d%d%d%d", as.integer(bits[10]),
                                         as.integer(bits[9]),
                                         as.integer(bits[8]),
                                         as.integer(bits[7]),
                                         as.integer(bits[6]),
                                         as.integer(bits[5]),
                                         as.integer(bits[4]),
                                         as.integer(bits[3]))
  cat(sprintf("DC1B = %s\n", dc1b))
  cat(sprintf("CCPR1L = %s\n", ccpr1l))
  
  return(on)
}

max_input = adc_max_input(5600, 3900)
adc_res = adc_resolution(max_input)

cat(sprintf("Maximum ADC Input: %.2fV\n", max_input))
cat(sprintf("ADC Resolution: %.1fmV\n", adc_res * 1000))
#print_adc_readings(7)
#print_adc_readings(8)

pwm_freq = 20000
cat(sprintf("\nPWM Parameters for %dkHz:\n", pwm_freq / 1000))
cat(sprintf("PR2 = %d\n", pwm_pr2(pwm_freq)))
print(pwm_duty_reg(pwm_pr2(pwm_freq), 0.86))
