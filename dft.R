#' dtf.R
#' Discrete Fourier Transform Implementation.
#' 
#' @author Nathan Campos <nathanpc@dreamintech.net>

samples = 200

x <- function (f, n) {
  sin((2 * pi * f * n) / samples)
}

Wk <- function (f, n) {
  (2 * pi * f * n) / samples
}

im_sum <- function (x_fun, fWk) {
  sm = 0

  for (n in 0:samples) {
    sm = sm + (x_fun(n) * sin(Wk(fWk, n)))
  }
  
  return(sm);
}

matplot(0:100, cbind(
    im_sum(function (n) { x(5, n) + 2*x(50, n) + x(95, n) }, 0:100),
    x(5, 0:100) + 2*x(50, 0:100) + x(95, 0:100)),
  type = "l", col = c("blue", "red"))
