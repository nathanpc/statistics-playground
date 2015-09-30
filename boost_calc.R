#' boost_calc.R
#' Simple caculator to assist in boost regulator designs.
#' Reference: https://learn.adafruit.com/diy-boost-calc/the-calculator
#' 
#' @author Nathan Campos <nathanpc@dreamintech.net>

ARDUINO_HIGH_FREQ = 62500
ARDUINO_FREQ = 31250

#' Calculates the minimum duty cycle.
#' 
#' @param vin_max Maximum input voltage.
#' @param vout_min Minimum output voltage.
#' @return Minimum duty cycle.
min_dtycycle <- function (vin_max, vout_min) {
  return(1 - (vin_max / vout_min))
}

#' Calculates the maximum duty cycle.
#' 
#' @param vin_min Minimum input voltage.
#' @param vout_max Maximum output voltage.
#' @return Maximum duty cycle.
max_dtycycle <- function (vin_min, vout_max) {
  return(1 - (vin_min / vout_max))
}

#' Calculate the minimum inductor value.
#' 
#' @param vin_max Maximum input voltage.
#' @param vout_min Minimum output voltage.
#' @param freq Switching frequency.
#' @param iout Output current draw.
#' @return Minimum inductor value in microhenries (uH).
min_inductor <- function (vin_max, vout_min, freq, iout) {
  l = min_dtycycle(vin_max, vout_min) * vin_max *
    (1 - min_dtycycle(vin_max, vout_min)) / (freq * 2 * iout)
  return(l * 10^6)
}

#' Calculates the peak inductor current.
#' 
#' @param vin_max Maximum input voltage.
#' @param vout_max Maximum output voltage.
#' @param freq Switching frequency.
#' @param l Inductor value in microhenries (uH).
#' @return Peak inductor current.
peak_inductor_i <- function (vin_max, vout_max, freq, l) {
  return((vin_max * min_dtycycle(vin_max, vout_max)) / (freq * l * 10^-6))
}

#' Calculates the minimum capacitor value.
#' 
#' @param iout Output current draw.
#' @param vripple Acceptable voltage ripple.
#' @param freq Switching frequency.
#' @return Minimum capacitor value in microfarads (uF).
min_cap <- function (iout, vripple, freq) {
  return((iout / (vripple * freq)) * 10^6)
}

#' Calculate the boost supply components and parameter values.
#' 
#' @param freq Switching frequency.
#' @param vin_min Minimum input voltage.
#' @param vin_max Maximum input voltge.
#' @param vout_min Minimum output voltage.
#' @param vout_max Maximum output voltage.
#' @param iout Output current draw.
#' @param vripple Acceptable output voltage ripple.
calc_main_params <- function (freq, vin_min, vin_max, vout_min, vout_max, iout,
                              vripple = 0.1) {
  mindty = min_dtycycle(vin_max, vout_min)
  maxdty = max_dtycycle(vin_min, vout_max)
  minl   = min_inductor(vin_max, vout_min, freq, iout)
  peakli = peak_inductor_i(vin_max, vout_max, freq, minl)
  mincap = min_cap(iout, vripple, freq)
  
  cat(sprintf("Min. Duty Cycle:       %.2f%%\n", mindty * 100))
  cat(sprintf("Max. Duty Cycle:       %.2f%%\n", maxdty * 100))
  cat(sprintf("Min. Inductor Value:   %.2fuH\n", minl))
  cat(sprintf("Peak Inductor Current: %.4fA\n", peakli))
  cat(sprintf("Minimum Capacitor:     %duF\n", mincap))
  cat(sprintf("Minimum Schottky Diode: Vbrk >= %.2fV & Idiode >= %.4fA\n", vout_max, peakli))
}

plot_l_peak_i <- function(vin_max, vout_max, freq, l) {
  graph = ggplot()
  graph = graph + scale_colour_brewer(palette="Set1")
  graph = graph + theme(legend.title = element_blank(),
                        legend.justification = c(1, 1),
                        legend.position = c(1, 1))
  
  for (f in 1:length(freq)) {
    df = data.frame(x = l, y = peak_inductor_i(vin_max, vout_max, freq[f], l),
                    name = sprintf("%.1f kHz", freq[f] / 1000))
    graph = graph + geom_line(data = df, aes(x, y, color = name))
  }
  
  # Setup labels and etc.
  graph = graph + scale_x_continuous("Inductance (uH)",
                                     breaks = pretty_breaks(n = 15))
  graph = graph + scale_y_continuous("Current (A)",
                                     breaks = pretty_breaks(n = 15))
  
  # Plot the data.
  print(graph)
}

##### TODO: Build a function to show the waveforms by using the duty cycle
#####       and a simple triangular shape function for the current.

