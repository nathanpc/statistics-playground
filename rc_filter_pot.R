#' rc_filter_pot.R
#' Calculates the response of a RC filter having its R controlled with
#' a potentiometer.
#' 
#' @author Nathan Campos <nathanpc@dreamintech.net>

library(googleVis)

#' Simulates (and plots) the filter.
#' 
#' @param r Potentiometer value (Ohms).
#' @param c Capacitor value (Farads).
simulate <- function (r, c) {
  cutoff = c()
  
  for (step in 1:r) {
    cutoff = c(cutoff, (1 / (2 * pi * step * c)))
  }
  
  return(cutoff)
}

#' Start the simulation.
#' 
#' @param r Potentiometer value (Ohms).
plot_simulations <- function (r) {
  df = data.frame(
    Steps = 1:r,
    "0.1uF" = simulate(r, 10^-7),
    "0.2uF" = simulate(r, 2 * 10^-7),
    "0.3uF" = simulate(r, 3 * 10^-7),
    "1uF" = simulate(r, 10^-6),
    "2.2uF" = simulate(r, 2.2 * 10^-6))
  
  graph = gvisLineChart(df,
                        options = list(legend = "none",
                                       width = 500,
                                       height = 500,
                                       hAxis = "{ title: 'Resistance' }",
                                       vAxis = "{ logScale: true,
                                                  title: 'Frequency Cutoff' }"))
  plot(graph)
}
