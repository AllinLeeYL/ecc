int a;
int b;
int main(){
    scanf("%d",&a);
    scanf("%d",&b);
    if((a<b)&&(a>b)){
        printf("Failed\n");
    }else{
        printf("Success\n");
    }
    return 0;
}