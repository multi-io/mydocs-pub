#!/usr/bin/ruby
# Rudolf Polzers Signatur
p proc{|f|f[lambda{|x|x+1}][0]}[proc{|o|proc{|m|proc{|a|m[m[a[o][o]][a[a[o
][o]][o]]][a[m[a[o][o]][a[o][a[o][o]]]][o]]}}}[lambda{|f|f}][proc{|f|proc{
|g|proc{|x|f[g[x]]}}}][proc{|f|proc{|g|proc{|h|proc{|x|f[h][g[h][x]]}}}}]]
