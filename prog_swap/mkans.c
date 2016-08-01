main()
{
int i,j;
int mem1[100], mem2[100];
for (i=0; i<100; i++) mem1[i]=rand()%256;
for (i=0; i<100; i++) mem2[i]=rand()%256<<16; 
for (i=0; i<100; i++) printf("%08x\n",mem2[i]); 
for (i=0; i<100; i++) printf("%08x\n",mem1[i]); 
}
