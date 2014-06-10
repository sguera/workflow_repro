POCHOIR_PATH="$BENCHROOT/StencilCompilers/pochoir/pochoir_v0.5"
echo "$POCHOIR_PATH"


export POCHOIR_LIB_PATH=$POCHOIR_PATH
$POCHOIR_PATH/pochoir -O3 -ipo -std=c++0x wave.cpp -o wave

CC=pochoir
stencil: stencil.cpp
    ${CC} -o stencil -O0 -g -debug stencil.cpp

CC=pochoir
stencil: stencil.cpp
    ${CC} -o stencil -O3 stencil.cpp

