main()
{
int i,j;
for (i=0; i<100; i++)  {
	j=rand()%100;
	if(j>=85) j=5;
	else if(j>=60) j=4;
	else if(j>=40) j=3;
	else if(j>=10) j=2;
	else  j=1;
	printf("%08x\n",j);
}
}
