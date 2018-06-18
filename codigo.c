int g;

int foo(int x, int y, int z[])
{
    z[0] = 0;
    y = x * y + 2;

    if(y == 0)
    {
        y = 1;
    }

    return y;
}