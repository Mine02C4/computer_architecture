main()
{
int i,j;
int mem[100];
for (i=0; i<100; i++) mem[i]=rand()%256;
for (i=0; i<100; i++) mem[i]= mem[i] | (rand()%256<<16); 
for (i=0; i<100; i++) printf("%08x\n",mem[i]); 
}
