# Vectors.
r1 <- NULL
i  <- NULL

# Constants.
Vin  <- 12
Vout <- 5

# Populate the R1 values.
for (r2 in 10:100) {#:1000000) {
  r <- ((r2 * Vin) / Vout) - r2
  i[r2 - 9] <- Vin / r

  r1[r2 - 9] <- r
}

g_range <- range(0, i, r1)

# Plot the graph.
plot(r1, type="o", col="red", ylim=g_range)
plot(i, type="o", col="blue")
