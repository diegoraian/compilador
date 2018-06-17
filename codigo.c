int a;

int func2(int a){
    func(a);
    return a;
}

void func(int a){
    while(a == 0){
        a = func2(a);
    }
}
