#!/usr/bin/env gnuplot
set terminal pngcairo

set key nobox
set key above

set xrange [0:0.2]
set xlabel "t"

unset logscale y 
set yrange [-5:7]
set ylabel "x(t)"

set output "../graph/transamp_none.png"
plot "../data/transamp_none.txt" using 1:2 with l ls 1 title "x_1(t)", \
     "../data/transamp_none.txt" using 1:3 with l ls 2 title "x_2(t)", \
     "../data/transamp_none.txt" using 1:4 with l ls 3 title "x_3(t)", \
     "../data/transamp_none.txt" using 1:5 with l ls 4 title "x_4(t)", \
     "../data/transamp_none.txt" using 1:6 with l ls 5 title "x_5(t)", \
     "../data/transamp_none.txt" using 1:7 with l ls 6 title "x_6(t)", \
     "../data/transamp_none.txt" using 1:8 with l ls 7 title "x_7(t)", \
     "../data/transamp_none.txt" using 1:9 with l ls 8 title "x_8(t)"

set output "../graph/transamp_sub.png"
plot "../data/transamp_sub.txt" using 1:2 with l ls 1 title "x_1(t)", \
     "../data/transamp_sub.txt" using 1:3 with l ls 2 title "x_2(t)", \
     "../data/transamp_sub.txt" using 1:4 with l ls 3 title "x_3(t)", \
     "../data/transamp_sub.txt" using 1:5 with l ls 4 title "x_4(t)", \
     "../data/transamp_sub.txt" using 1:6 with l ls 5 title "x_5(t)", \
     "../data/transamp_sub.txt" using 1:7 with l ls 6 title "x_6(t)", \
     "../data/transamp_sub.txt" using 1:8 with l ls 7 title "x_7(t)", \
     "../data/transamp_sub.txt" using 1:9 with l ls 8 title "x_8(t)"
     
set output "../graph/transamp_aug.png"
plot "../data/transamp_aug.txt" using 1:2 with l ls 1 title "x_1(t)", \
     "../data/transamp_aug.txt" using 1:3 with l ls 2 title "x_2(t)", \
     "../data/transamp_aug.txt" using 1:4 with l ls 3 title "x_3(t)", \
     "../data/transamp_aug.txt" using 1:5 with l ls 4 title "x_4(t)", \
     "../data/transamp_aug.txt" using 1:6 with l ls 5 title "x_5(t)", \
     "../data/transamp_aug.txt" using 1:7 with l ls 6 title "x_6(t)", \
     "../data/transamp_aug.txt" using 1:8 with l ls 7 title "x_7(t)", \
     "../data/transamp_aug.txt" using 1:9 with l ls 8 title "x_8(t)"

set terminal tikz size 5.33cm, 4cm fontscale 0.6
set xlabel "$t$" offset 0, 0.5
set ylabel "$x(t)$" offset 1, 0
set ytics offset 1, 0
set ticscale 0.5
set key above Left samplen 2.5 height 1

set output "../tikz/transamp_none.tex"
plot "../data/transamp_none.txt" every 10 using 1:2 with l ls 1 title "$x_1(t)$", \
     "../data/transamp_none.txt" every 10 using 1:3 with l ls 2 title "$x_2(t)$", \
     "../data/transamp_none.txt" every 10 using 1:4 with l ls 3 title "$x_3(t)$", \
     "../data/transamp_none.txt" every 10 using 1:5 with l ls 4 title "$x_4(t)$", \
     "../data/transamp_none.txt" every 10 using 1:6 with l ls 5 title "$x_5(t)$", \
     "../data/transamp_none.txt" every 10 using 1:7 with l ls 6 title "$x_6(t)$", \
     "../data/transamp_none.txt" every 10 using 1:8 with l ls 7 title "$x_7(t)$", \
     "../data/transamp_none.txt" every 10 using 1:9 with l ls 8 title "$x_8(t)$"

set output "../tikz/transamp_sub.tex"
plot "../data/transamp_sub.txt" every 10 using 1:2 with l ls 1 title "$x_1(t)$", \
     "../data/transamp_sub.txt" every 10 using 1:3 with l ls 2 title "$x_2(t)$", \
     "../data/transamp_sub.txt" every 10 using 1:4 with l ls 3 title "$x_3(t)$", \
     "../data/transamp_sub.txt" every 10 using 1:5 with l ls 4 title "$x_4(t)$", \
     "../data/transamp_sub.txt" every 10 using 1:6 with l ls 5 title "$x_5(t)$", \
     "../data/transamp_sub.txt" every 10 using 1:7 with l ls 6 title "$x_6(t)$", \
     "../data/transamp_sub.txt" every 10 using 1:8 with l ls 7 title "$x_7(t)$", \
     "../data/transamp_sub.txt" every 10 using 1:9 with l ls 8 title "$x_8(t)$"
     
set output "../tikz/transamp_aug.tex"
plot "../data/transamp_aug.txt" every 10 using 1:2 with l ls 1 title "$x_1(t)$", \
     "../data/transamp_aug.txt" every 10 using 1:3 with l ls 2 title "$x_2(t)$", \
     "../data/transamp_aug.txt" every 10 using 1:4 with l ls 3 title "$x_3(t)$", \
     "../data/transamp_aug.txt" every 10 using 1:5 with l ls 4 title "$x_4(t)$", \
     "../data/transamp_aug.txt" every 10 using 1:6 with l ls 5 title "$x_5(t)$", \
     "../data/transamp_aug.txt" every 10 using 1:7 with l ls 6 title "$x_6(t)$", \
     "../data/transamp_aug.txt" every 10 using 1:8 with l ls 7 title "$x_7(t)$", \
     "../data/transamp_aug.txt" every 10 using 1:9 with l ls 8 title "$x_8(t)$"

reset
