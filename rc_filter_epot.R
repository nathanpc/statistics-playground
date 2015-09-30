#' rc_filter_epot.R
#' Calculates the response of a RC filter having its R controlled with
#' a digital potentiometer.
#' 
#' @author Nathan Campos <nathanpc@dreamintech.net>

library(googleVis)

#' Simulates (and plots) the filter.
#' 
#' @param r Potentiometer value (Ohms).
#' @param c Capacitor value (Farads).
#' @param steps Digital potentiometer steps (256 for a 8 bit one).
simulate <- function (r, c, steps) {
  step_r = r / steps
  cutoff = c()
  
  for (step in 1:steps) {
    cutoff = c(cutoff, (1 / (2 * pi * (step * step_r) * c)))
  }
  
  return(cutoff)
}

# Start the simulation.
plot_simulations <- function () {
  # MCP41100 (100k 8-bit)
  df = data.frame(
    Steps = 1:256,
    "10nF" = simulate(100000, 10^-8, 256),
    "15nF" = simulate(100000, 1.5*10^-8, 256),
    "20nF" = simulate(100000, 2*10^-8, 256))
  
  graph = gvisLineChart(df,
                        options = list(legend = "none",
                                       width = 500,
                                       height = 500,
                                       hAxis = "{ title: 'Digital Potentiometer Steps' }",
                                       vAxis = "{ logScale: true,
                                                  title: 'Frequency Cutoff' }"))
  plot(graph)
}
