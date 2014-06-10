head -n 114 temp1.c > temp2.c
printf "if(t5 %% 3 == 0) {" >> temp2.c
sed -n '115,117p' temp1.c | sed 's/u\[t5+2\]/u\[2\]/g' | sed 's/u\[t5+1\]/u\[1\]/g' | sed 's/u\[t5\]/u\[0\]/g' >>temp2.c
printf "} else if(t5 %% 3 == 1) {\n" >> temp2.c
sed -n '115,117p' temp1.c | sed 's/u\[t5+2\]/u\[0\]/g' | sed 's/u\[t5+1\]/u\[2\]/g' | sed 's/u\[t5\]/u\[1\]/g' >>temp2.c
printf "} else {\n" >> temp2.c
sed -n '115,117p' temp1.c | sed 's/u\[t5+2\]/u\[1\]/g' | sed 's/u\[t5+1\]/u\[0\]/g' | sed 's/u\[t5\]/u\[2\]/g' >>temp2.c
printf "}" >> temp2.c
tail -n +118 temp1.c >>temp2.c

#sed -in '/if(/,/else{/ s/u\[t5\]/u\[0\]/g' temp2.c
#sed -in '/if(/,/else{/ s/u\[t5+1\]/u\[1\]/g' temp2.c
#sed -in '/else{/,/icc/ s/u\[t5+1\]/u\[0\]/g' temp2.c
#sed -in '/else{/,/icc/ s/u\[t5\]/u\[1\]/g' temp2.c
