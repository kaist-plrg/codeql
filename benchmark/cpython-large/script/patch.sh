for app in `ls src`; do
  cp resource/Makefile src/$app
  cp resource/post-compile.sh src/$app
done

#distance
cp resource/distance.c src/distance/cdistance/distance.c
cp resource/setup.py src/distance/setup.py

#cvxopt
cp resource/cvxopt.h src/cvxopt/src/C/cvxopt.h
cp resource/lapack.c src/cvxopt/src/C/lapack.c

#japranto
cd src/japronto
rm -f special.sh
cmd="`make | grep "cparser.c -o"` -DPARSER_STANDALONE"
echo $cmd > post-compile.sh
chmod 744 post-compile.sh
