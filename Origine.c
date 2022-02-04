int elabora(char *st, int d)
{ int i,conta;
conta=0;
for(i=0;i<d;i++)
if(st[i]-48<5)
conta++;
return conta;
}
main() {
char str[32];
int I,ris;
do
{
printf("Inserisci una stringa di soli numeri\n");
scanf("%s",str);
ris=elabora(str,strlen(str));
printf(" Valore= %d \n",ris);
i++;
} while (i<3);
}
