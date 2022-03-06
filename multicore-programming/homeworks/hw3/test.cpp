#include <iostream>
#include <cstdlib>

using namespace std;
int i;
int array[30];
int odd;
int my_max;
int counter;

int main()
{	
	for (int j = 0;j<30;j++)
	{

		i = rand() % 101;
		 array[j]=i;
	}

	for (int k = 0; k < 30 ; k++)
	{
		cout << array[k] << " ";

	}

	
	return 0;
}