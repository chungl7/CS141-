#include "vector.h"

int main() // Here is a start:

{

        Vector<int> intVec{1,3,5,7,9};

        Vector<double> doubleVec{1.5,2.5,3.5,4.5};

        Vector<int> iv{intVec};

        Vector<double> dv{doubleVec};

        cout << "intVec" << intVec << endl;

// "intVec(1, 3, 5, 7, 9)"

        cout << "iv" << iv << endl;

// "iv(1, 3, 5, 7, 9)"

        cout << "doubleVec" << doubleVec << endl;

// "doubleVec(1.5, 2.5, 3.5, 4.5)"

cout << "dv" << dv << endl;


// "dv(1.5, 2.5, 3.5, 4.5)"


        // add at least one test case for each method defined in Vector

return 0;

}