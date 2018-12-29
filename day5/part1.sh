#!/bin/bash
input=$(cat in.txt)
while true; do
    inlen=${#input}

    input=$(sed -e 's/qQ//g' -e 's/Qq//g' -e 's/wW//g' -e 's/Ww//g' -e 's/eE//g' -e 's/Ee//g' -e 's/rR//g' -e 's/Rr//g' -e 's/tT//g' -e 's/Tt//g' -e 's/yY//g' -e 's/Yy//g' -e 's/uU//g' -e 's/Uu//g' -e 's/iI//g' -e 's/Ii//g' -e 's/oO//g' -e 's/Oo//g' -e 's/pP//g' -e 's/Pp//g' -e 's/aA//g' -e 's/Aa//g' -e 's/sS//g' -e 's/Ss//g' -e 's/dD//g' -e 's/Dd//g' -e 's/fF//g' -e 's/Ff//g' -e 's/gG//g' -e 's/Gg//g' -e 's/hH//g' -e 's/Hh//g' -e 's/jJ//g' -e 's/Jj//g' -e 's/kK//g' -e 's/Kk//g' -e 's/lL//g' -e 's/Ll//g' -e 's/zZ//g' -e 's/Zz//g' -e 's/xX//g' -e 's/Xx//g' -e 's/cC//g' -e 's/Cc//g' -e 's/vV//g' -e 's/Vv//g' -e 's/bB//g' -e 's/Bb//g' -e 's/nN//g' -e 's/Nn//g' -e 's/mM//g' -e 's/Mm//g' <<<$input)
    outlen=${#input}
    if [ $outlen -eq $inlen ]; then
         break
    fi
done
echo ${#input}
