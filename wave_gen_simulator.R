#' wave_gen_simulator.R
#' Simulates simple waveform.
#' 
#' @author Nathan Campos <nathanpc@dreamintech.net>

library("ggplot2")

values <- c()
#for (step in 1:256) {
#  values <- c(values, sin(2*pi*1000/256*step))
#}
values <- sin(0:1)

qplot(1:length(values), values, geom = "line")