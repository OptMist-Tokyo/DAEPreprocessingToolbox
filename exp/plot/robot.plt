#!/usr/bin/env gnuplot
set terminal pngcairo

set key nobox
set key above

set xrange [0:1.4]
set xlabel "t"

unset logscale y 
set yrange [-5:25]
set ylabel "x(t)"

set output "../graph/robot_none.png"
plot "../data/robot_none.txt" using 1:2 with l ls 1 title "x_1(t)", \
     "../data/robot_none.txt" using 1:3 with l ls 2 title "x_2(t)", \
     "../data/robot_none.txt" using 1:4 with l ls 3 title "x_3(t)", \
     "../data/robot_none.txt" using 1:5 with l ls 4 title "x_4(t)", \
     "../data/robot_none.txt" using 1:6 with l ls 5 title "x_5(t)"

set output "../graph/robot_sub.png"
plot "../data/robot_sub.txt" using 1:2 with l ls 1 title "x_1(t)", \
     "../data/robot_sub.txt" using 1:3 with l ls 2 title "x_2(t)", \
     "../data/robot_sub.txt" using 1:4 with l ls 3 title "x_3(t)", \
     "../data/robot_sub.txt" using 1:5 with l ls 4 title "x_4(t)", \
     "../data/robot_sub.txt" using 1:6 with l ls 5 title "x_5(t)"
     
set output "../graph/robot_aug.png"
plot "../data/robot_aug.txt" using 1:2 with l ls 1 title "x_1(t)", \
     "../data/robot_aug.txt" using 1:3 with l ls 2 title "x_2(t)", \
     "../data/robot_aug.txt" using 1:4 with l ls 3 title "x_3(t)", \
     "../data/robot_aug.txt" using 1:5 with l ls 4 title "x_4(t)", \
     "../data/robot_aug.txt" using 1:6 with l ls 5 title "x_5(t)"

set terminal tikz size 5.33cm, 4cm fontscale 0.6
set xlabel "$t$" offset 0, 0.5
set ylabel "$x(t)$" offset 1, 0
set ytics offset 1, 0
set ticscale 0.5
set key above Left samplen 2.5 height 1

set output "../tikz/robot_none.tex"
plot "../data/robot_none.txt" every 1 using 1:2 with l ls 1 title "$x_1(t)$", \
     "../data/robot_none.txt" every 1 using 1:3 with l ls 2 title "$x_2(t)$", \
     "../data/robot_none.txt" every 1 using 1:4 with l ls 3 title "$x_3(t)$", \
     "../data/robot_none.txt" every 1 using 1:5 with l ls 4 title "$x_4(t)$", \
     "../data/robot_none.txt" every 1 using 1:6 with l ls 5 title "$x_5(t)$"

set output "../tikz/robot_sub.tex"
plot "../data/robot_sub.txt" every 1 using 1:2 with l ls 1 title "$x_1(t)$", \
     "../data/robot_sub.txt" every 1 using 1:3 with l ls 2 title "$x_2(t)$", \
     "../data/robot_sub.txt" every 1 using 1:4 with l ls 3 title "$x_3(t)$", \
     "../data/robot_sub.txt" every 1 using 1:5 with l ls 4 title "$x_4(t)$", \
     "../data/robot_sub.txt" every 1 using 1:6 with l ls 5 title "$x_5(t)$"
     
set output "../tikz/robot_aug.tex"
plot "../data/robot_aug.txt" every 1 using 1:2 with l ls 1 title "$x_1(t)$", \
     "../data/robot_aug.txt" every 1 using 1:3 with l ls 2 title "$x_2(t)$", \
     "../data/robot_aug.txt" every 1 using 1:4 with l ls 3 title "$x_3(t)$", \
     "../data/robot_aug.txt" every 1 using 1:5 with l ls 4 title "$x_4(t)$", \
     "../data/robot_aug.txt" every 1 using 1:6 with l ls 5 title "$x_5(t)$"

reset
