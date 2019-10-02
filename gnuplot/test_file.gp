# test_file.gnuplot
# Simple example of how to plot information from a file.

set datafile separator ","
plot "temp.csv" using 0:2
pause -1

