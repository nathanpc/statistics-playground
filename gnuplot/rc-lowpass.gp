# Title.
set title "RC Low-Pass Filter"

# Functions and variables.
r1 = 1000
c = 0.1 * 10**-6
r(x) = 1 / (2 * pi * x * c)
f(x) = 20 * log10(r(x) / (r1 + r(x)))

# Disable the legend.
set key off

# Setup the axis.
set xrange [1:1000000]
set yrange [-60:0]
set xlabel "Frequency (Hz)"
set ylabel "Magnitude (dB)"
set format x "%.0s%c"
set logscale x
set autoscale x

#set label 1 "test" at 1000,-20

# Plot.
plot f(x) title "0.1uF"
pause -1

