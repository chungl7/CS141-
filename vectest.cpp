#include "vector.h"
#include "cassert"

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

        assert(doubleVec.size() == 4);
        assert(intVec.size() == 5);
        assert(dv.size() == 4);
        assert(iv.size() == 5);

        iv[0] = 10;
        dv[0] = 10.0;
        assert(iv[0] == 10);
        assert(intVec[0] == 1);
        assert(dv[0] == 10.0);
        assert(doubleVec[0] == 1.5);

        Vector<int>test1{1,2,3,4};
        assert(intVec * test1 == 50);

        Vector<int> a{1,2,3}, b{1,2,3,4};
        Vector<int> c = a + b;
        assert(c.size() == 4);
        assert(c[0] == 2 && c[1] == 4 && c[2] == 6 && c[3] == 4);
        Vector<double> a1{1.1, 2.2, 3.3}, b1{1.1};
        Vector<double> c1 = a1 + b1;
        assert(c1.size() == 3);
        assert(c1[0] == 2.2 && c1[1] == 2.2 && c1[2] == 3.3);

        Vector<int> test2 {0,1,2};
        test2 = intVec;
        assert(test2.size() == intVec.size());
        test2[1] = 22;
        assert(intVec[1] == 3);

        assert(intVec != test2);
        Vector<double> test3 {1.5,2.5,3.5,4.5};
        assert(test3 == doubleVec);


        Vector<int> scaled = 2 * test2;
        Vector<double> shifted = 30 + test3;
        assert(scaled[1] == 44);
        assert(shifted[1] == 32.5);

        cout << "All test done!";

        return 0;

}