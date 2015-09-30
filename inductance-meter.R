freq <- function (p) {
  return(1E6 / (2 * p));
}

lc_freq <- function (l, c) {
  return(1 / (2 * pi * sqrt(l * c)));
}

l <- function (c, f) {
  return(1 / (4 * c * (f ^ 2) * (pi ^ 2)))
}

c <- 2E-6
inductance <- l(c, lc_freq(10E-6, c)) * 1E6

print(paste(inductance, "uH"))
