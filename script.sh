make;
make clean;
./compilador codigo.c out.asm
spim -file out.asm
