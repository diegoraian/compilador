int a;
/*asdasdaasdasdsd*/

int func2(int a){
    func(a);
	a = 20;
    return a;
}
/*asdasdasdasdsfaf*/
void func(int a){
    while(a == 0){
        a = func2(a);
    }
}
