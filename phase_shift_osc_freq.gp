set title "Phase Shift Oscillator"

f1(x) = 1 / (2 * pi * x * 1e-7 * sqrt(6))
f2(x) = 1 / (2 * pi * x * 1e-8 * sqrt(6))
f3(x) = 1 / (2 * pi * x * 1e-9 * sqrt(6))
f4(x) = 1 / (2 * pi * x * 1e-10 * sqrt(6))

set style function filledcurves y1=0
set style fill transparent solid 0.5 noborder
set key top reverse samplen 1
set xrange [300:10000]

plot f2(x) title "1nF", \
     f1(x) title "10nF"