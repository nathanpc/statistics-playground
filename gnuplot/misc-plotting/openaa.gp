set title 'FFT Plot'
set ylabel 'Amplitude (V)'
set xlabel 'Frequency (Hz)'
set grid
set datafile separator ','
set term wxt 0
plot "fft.csv" using 1:2 with lines
pause 5

