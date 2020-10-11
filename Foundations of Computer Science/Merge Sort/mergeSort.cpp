#include <iostream> 
#include <ctime>
using namespace std;

void printArray(int[], int);
void initArray(int[], int);
void mergeSort(int[], int , int );
void merge(int[], int, int, int);

int main(){
    
    const int SIZE =10;
    int array[SIZE];
    initArray(array, SIZE);

    cout << "The unsorted array is : ";
    printArray(array, SIZE);

    int low = 0;
    int high = SIZE-1;

    mergeSort(array, low, high);
    cout << "Merge Sorting..." << endl << endl;

    cout << "The sorted array: ";
    printArray(array, SIZE);
}

void printArray(int arr[], int size)
{
    for(int i=0; i<size; i++)
    {
        cout << arr[i] << "  ";
    }
    cout << endl << endl;
}

void initArray(int arr[], int size)
{
    srand(time(NULL));
    for(int i=0; i<size; i++)
    {
        arr[i] = rand() % 100;
    }
}
void mergeSort(int arr[], int low, int high)
{
    if (low < high)
    {
        int mid = low+(high-low)/2;
        mergeSort(arr, low, mid);
        mergeSort(arr, mid+1, high);
        merge(arr, low, mid, high);
    }
}

void merge(int arr[], int low, int mid, int high)
{
    int i, j, k;
    const int SIZEL = mid - low + 1;
    const int SIZER = high - mid;
    int *L = new int[SIZEL];
    int *R = new int[SIZER];

    for (i = 0; i < SIZEL; i++)
        L[i] = arr[low + i];
    for (j = 0; j < SIZER; j++)
        R[j] = arr[mid + 1+ j];

    i = 0; 
    j = 0; 
    k = low; 

    while (i < SIZEL && j < SIZER)
    {
        if (L[i] <= R[j])
        {
            arr[k] = L[i];
            i++;
        }
        else
        {
            arr[k] = R[j];
            j++;
        }
        k++;
    }

    while (i < SIZEL)
    {
        arr[k] = L[i];
        i++;
        k++;
    }

    while (j < SIZER)
    {
        arr[k] = R[j];
        j++;
        k++;
    }
}