#!/usr/bin/env gnuplot
set terminal pngcairo

set key nobox
set key above

set xrange [0:1e-3]
set xlabel "t"

unset logscale y 
set yrange [-1:1]
set ylabel "x(t)"

set output "../graph/ringmod_none.png"
plot "../data/ringmod_none.txt" using 1:2 with l ls 1 title "x_1(t)", \
     "../data/ringmod_none.txt" using 1:3 with l ls 2 title "x_2(t)", \
     "../data/ringmod_none.txt" using 1:4 with l ls 3 title "x_3(t)", \
     "../data/ringmod_none.txt" using 1:5 with l ls 4 title "x_4(t)", \
     "../data/ringmod_none.txt" using 1:6 with l ls 5 title "x_5(t)", \
     "../data/ringmod_none.txt" using 1:7 with l ls 6 title "x_6(t)", \
     "../data/ringmod_none.txt" using 1:8 with l ls 7 title "x_7(t)", \
     "../data/ringmod_none.txt" using 1:9 with l ls 8 title "x_8(t)", \
     "../data/ringmod_none.txt" using 1:9 with l ls 9 title "x_9(t)", \
     "../data/ringmod_none.txt" using 1:9 with l ls 10 title "x_{10}(t)", \
     "../data/ringmod_none.txt" using 1:9 with l ls 11 title "x_{11}(t)", \
     "../data/ringmod_none.txt" using 1:3 with l ls 12 title "x_{12}(t)", \
     "../data/ringmod_none.txt" using 1:4 with l ls 13 title "x_{13}(t)", \
     "../data/ringmod_none.txt" using 1:5 with l ls 14 title "x_{14}(t)", \
     "../data/ringmod_none.txt" using 1:6 with l ls 15 title "x_{15}(t)"

set output "../graph/ringmod_sub.png"
set arrow from 0.000501,-1 to 0.000501,1 nohead lw 2 dt '-'
plot "../data/ringmod_sub.txt" using 1:2 with l ls 1 title "x_1(t)", \
     "../data/ringmod_sub.txt" using 1:3 with l ls 2 title "x_2(t)", \
     "../data/ringmod_sub.txt" using 1:4 with l ls 3 title "x_3(t)", \
     "../data/ringmod_sub.txt" using 1:5 with l ls 4 title "x_4(t)", \
     "../data/ringmod_sub.txt" using 1:6 with l ls 5 title "x_5(t)", \
     "../data/ringmod_sub.txt" using 1:7 with l ls 6 title "x_6(t)", \
     "../data/ringmod_sub.txt" using 1:8 with l ls 7 title "x_7(t)", \
     "../data/ringmod_sub.txt" using 1:9 with l ls 8 title "x_8(t)", \
     "../data/ringmod_sub.txt" using 1:9 with l ls 9 title "x_9(t)", \
     "../data/ringmod_sub.txt" using 1:9 with l ls 10 title "x_{10}(t)", \
     "../data/ringmod_sub.txt" using 1:9 with l ls 11 title "x_{11}(t)", \
     "../data/ringmod_sub.txt" using 1:3 with l ls 12 title "x_{12}(t)", \
     "../data/ringmod_sub.txt" using 1:4 with l ls 13 title "x_{13}(t)", \
     "../data/ringmod_sub.txt" using 1:5 with l ls 14 title "x_{14}(t)", \
     "../data/ringmod_sub.txt" using 1:6 with l ls 15 title "x_{15}(t)"
unset arrow

set output "../graph/ringmod_aug.png"
plot "../data/ringmod_aug.txt" using 1:2 with l ls 1 title "x_1(t)", \
     "../data/ringmod_aug.txt" using 1:3 with l ls 2 title "x_2(t)", \
     "../data/ringmod_aug.txt" using 1:4 with l ls 3 title "x_3(t)", \
     "../data/ringmod_aug.txt" using 1:5 with l ls 4 title "x_4(t)", \
     "../data/ringmod_aug.txt" using 1:6 with l ls 5 title "x_5(t)", \
     "../data/ringmod_aug.txt" using 1:7 with l ls 6 title "x_6(t)", \
     "../data/ringmod_aug.txt" using 1:8 with l ls 7 title "x_7(t)", \
     "../data/ringmod_aug.txt" using 1:9 with l ls 8 title "x_8(t)", \
     "../data/ringmod_aug.txt" using 1:9 with l ls 9 title "x_9(t)", \
     "../data/ringmod_aug.txt" using 1:9 with l ls 10 title "x_{10}(t)", \
     "../data/ringmod_aug.txt" using 1:9 with l ls 11 title "x_{11}(t)", \
     "../data/ringmod_aug.txt" using 1:3 with l ls 12 title "x_{12}(t)", \
     "../data/ringmod_aug.txt" using 1:4 with l ls 13 title "x_{13}(t)", \
     "../data/ringmod_aug.txt" using 1:5 with l ls 14 title "x_{14}(t)", \
     "../data/ringmod_aug.txt" using 1:6 with l ls 15 title "x_{15}(t)"

set terminal tikz size 5.33cm, 4.75cm fontscale 0.6
set xlabel "$t$" offset 0, 0.5
set ylabel "$x(t)$" offset 2, 0
set ytics offset 1, 0
set ticscale 0.5
set key above Left samplen 2.5 height 1

set output "../tikz/ringmod_none.tex"
plot "../data/ringmod_none.txt" every 10 using 1:2 with l ls 1 title "$x_1(t)$", \
     "../data/ringmod_none.txt" every 10 using 1:3 with l ls 2 title "$x_2(t)$", \
     "../data/ringmod_none.txt" every 10 using 1:4 with l ls 3 title "$x_3(t)$", \
     "../data/ringmod_none.txt" every 10 using 1:5 with l ls 4 title "$x_4(t)$", \
     "../data/ringmod_none.txt" every 10 using 1:6 with l ls 5 title "$x_5(t)$", \
     "../data/ringmod_none.txt" every 10 using 1:7 with l ls 6 title "$x_6(t)$", \
     "../data/ringmod_none.txt" every 10 using 1:8 with l ls 7 title "$x_7(t)$", \
     "../data/ringmod_none.txt" every 10 using 1:9 with l ls 8 title "$x_8(t)$", \
     "../data/ringmod_none.txt" every 10 using 1:10 with l ls 9 title "$x_9(t)$", \
     "../data/ringmod_none.txt" every 10 using 1:11 with l ls 10 title "$x_{10}(t)$", \
     "../data/ringmod_none.txt" every 10 using 1:12 with l ls 11 title "$x_{11}(t)$", \
     "../data/ringmod_none.txt" every 10 using 1:13 with l ls 12 title "$x_{12}(t)$", \
     "../data/ringmod_none.txt" every 10 using 1:14 with l ls 13 title "$x_{13}(t)$", \
     "../data/ringmod_none.txt" every 10 using 1:15 with l ls 14 title "$x_{14}(t)$", \
     "../data/ringmod_none.txt" every 10 using 1:16 with l ls 15 title "$x_{15}(t)$"
 
set output "../tikz/ringmod_sub.tex"
set arrow from 0.000501,-1 to 0.000501,1 nohead lw 2 dt (3, 5)
plot "../data/ringmod_sub.txt" every 10 using 1:2 with l ls 1 title "$x_1(t)$", \
     "../data/ringmod_sub.txt" every 10 using 1:3 with l ls 2 title "$x_2(t)$", \
     "../data/ringmod_sub.txt" every 10 using 1:4 with l ls 3 title "$x_3(t)$", \
     "../data/ringmod_sub.txt" every 10 using 1:5 with l ls 4 title "$x_4(t)$", \
     "../data/ringmod_sub.txt" every 10 using 1:6 with l ls 5 title "$x_5(t)$", \
     "../data/ringmod_sub.txt" every 10 using 1:7 with l ls 6 title "$x_6(t)$", \
     "../data/ringmod_sub.txt" every 10 using 1:8 with l ls 7 title "$x_7(t)$", \
     "../data/ringmod_sub.txt" every 10 using 1:9 with l ls 8 title "$x_8(t)$", \
     "../data/ringmod_sub.txt" every 10 using 1:10 with l ls 9 title "$x_9(t)$", \
     "../data/ringmod_sub.txt" every 10 using 1:11 with l ls 10 title "$x_{10}(t)$", \
     "../data/ringmod_sub.txt" every 10 using 1:12 with l ls 11 title "$x_{11}(t)$", \
     "../data/ringmod_sub.txt" every 10 using 1:13 with l ls 12 title "$x_{12}(t)$", \
     "../data/ringmod_sub.txt" every 10 using 1:14 with l ls 13 title "$x_{13}(t)$", \
     "../data/ringmod_sub.txt" every 10 using 1:15 with l ls 14 title "$x_{14}(t)$", \
     "../data/ringmod_sub.txt" every 10 using 1:16 with l ls 15 title "$x_{15}(t)$"
unset arrow
     
set output "../tikz/ringmod_aug.tex"
plot "../data/ringmod_aug.txt" every 10 using 1:2 with l ls 1 title "$x_1(t)$", \
     "../data/ringmod_aug.txt" every 10 using 1:3 with l ls 2 title "$x_2(t)$", \
     "../data/ringmod_aug.txt" every 10 using 1:4 with l ls 3 title "$x_3(t)$", \
     "../data/ringmod_aug.txt" every 10 using 1:5 with l ls 4 title "$x_4(t)$", \
     "../data/ringmod_aug.txt" every 10 using 1:6 with l ls 5 title "$x_5(t)$", \
     "../data/ringmod_aug.txt" every 10 using 1:7 with l ls 6 title "$x_6(t)$", \
     "../data/ringmod_aug.txt" every 10 using 1:8 with l ls 7 title "$x_7(t)$", \
     "../data/ringmod_aug.txt" every 10 using 1:9 with l ls 8 title "$x_8(t)$", \
     "../data/ringmod_aug.txt" every 10 using 1:10 with l ls 9 title "$x_9(t)$", \
     "../data/ringmod_aug.txt" every 10 using 1:11 with l ls 10 title "$x_{10}(t)$", \
     "../data/ringmod_aug.txt" every 10 using 1:12 with l ls 11 title "$x_{11}(t)$", \
     "../data/ringmod_aug.txt" every 10 using 1:13 with l ls 12 title "$x_{12}(t)$", \
     "../data/ringmod_aug.txt" every 10 using 1:14 with l ls 13 title "$x_{13}(t)$", \
     "../data/ringmod_aug.txt" every 10 using 1:15 with l ls 14 title "$x_{14}(t)$", \
     "../data/ringmod_aug.txt" every 10 using 1:16 with l ls 15 title "$x_{15}(t)$"

reset
