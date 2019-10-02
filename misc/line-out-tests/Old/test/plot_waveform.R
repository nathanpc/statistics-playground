# plot_waveform.R

big <- read.csv("~/Desktop/Amplifier Stuff/Waveform Examples/test/big.csv", header=F)
plot.default(big, type="h", col="red")
