main()
{
int i,j;
for (i=0; i<100; i++) 
	printf("%08x\n",rand()%256);
for (i=0; i<100; i++) 
	printf("%08x\n",rand()%256<<16);
}
