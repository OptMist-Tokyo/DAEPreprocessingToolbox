#!/usr/bin/env gnuplot
set terminal pngcairo

set key nobox
set key above

set xrange [0:5]
set xlabel "t"

unset logscale y 
set yrange [-4:13]
set ylabel "x(t)"

set output "../graph/pendulum_none.png"
plot "../data/pendulum_none.txt" using 1:2 with l ls 1 title "x_1(t)", \
     "../data/pendulum_none.txt" using 1:3 with l ls 2 title "x_2(t)", \
     "../data/pendulum_none.txt" using 1:4 with l ls 3 title "x_3(t)", \
     "../data/pendulum_none.txt" using 1:5 with l ls 4 title "x_4(t)", \
     "../data/pendulum_none.txt" using 1:6 with l ls 5 title "x_5(t)"

set output "../graph/pendulum_sub.png"
plot "../data/pendulum_sub.txt" using 1:2 with l ls 1 title "x_1(t)", \
     "../data/pendulum_sub.txt" using 1:3 with l ls 2 title "x_2(t)", \
     "../data/pendulum_sub.txt" using 1:4 with l ls 3 title "x_3(t)", \
     "../data/pendulum_sub.txt" using 1:5 with l ls 4 title "x_4(t)", \
     "../data/pendulum_sub.txt" using 1:6 with l ls 5 title "x_5(t)"
     
set output "../graph/pendulum_aug.png"
plot "../data/pendulum_aug.txt" using 1:2 with l ls 1 title "x_1(t)", \
     "../data/pendulum_aug.txt" using 1:3 with l ls 2 title "x_2(t)", \
     "../data/pendulum_aug.txt" using 1:4 with l ls 3 title "x_3(t)", \
     "../data/pendulum_aug.txt" using 1:5 with l ls 4 title "x_4(t)", \
     "../data/pendulum_aug.txt" using 1:6 with l ls 5 title "x_5(t)"

set terminal tikz size 5.33cm, 4cm fontscale 0.6
set xlabel "$t$" offset 0, 0.5
set ylabel "$x(t)$" offset 1, 0
set ytics offset 1, 0
set ticscale 0.5
set key above Left samplen 2.5 height 1

set output "../tikz/pendulum_none.tex"
plot "../data/pendulum_none.txt" using 1:2 with l ls 1 title "$x_1(t)$", \
     "../data/pendulum_none.txt" using 1:3 with l ls 2 title "$x_2(t)$", \
     "../data/pendulum_none.txt" using 1:4 with l ls 3 title "$x_3(t)$", \
     "../data/pendulum_none.txt" using 1:5 with l ls 4 title "$x_4(t)$", \
     "../data/pendulum_none.txt" using 1:6 with l ls 5 title "$x_5(t)$"

set output "../tikz/pendulum_sub.tex"
plot "../data/pendulum_sub.txt" using 1:2 with l ls 1 title "$x_1(t)$", \
     "../data/pendulum_sub.txt" using 1:3 with l ls 2 title "$x_2(t)$", \
     "../data/pendulum_sub.txt" using 1:4 with l ls 3 title "$x_3(t)$", \
     "../data/pendulum_sub.txt" using 1:5 with l ls 4 title "$x_4(t)$", \
     "../data/pendulum_sub.txt" using 1:6 with l ls 5 title "$x_5(t)$"
     
set output "../tikz/pendulum_aug.tex"
plot "../data/pendulum_aug.txt" using 1:2 with l ls 1 title "$x_1(t)$", \
     "../data/pendulum_aug.txt" using 1:3 with l ls 2 title "$x_2(t)$", \
     "../data/pendulum_aug.txt" using 1:4 with l ls 3 title "$x_3(t)$", \
     "../data/pendulum_aug.txt" using 1:5 with l ls 4 title "$x_4(t)$", \
     "../data/pendulum_aug.txt" using 1:6 with l ls 5 title "$x_5(t)$"

reset
