#ifndef VECTOR_H

#define VECTOR_H

#include <iostream>

using namespace std;


/* Commented by Safeeullah Saifuddin, Fall 2022 */

/** ADVISED ORDER OF IMPLEMENTATION

 * 1. Constructors

 * 2. Inserter (<<) -> allows you to print & see what is in the vector throughout development

 * 3. Write test cases that use some of the constructors and print those vectors out

 * 4. Write a test case for a function

 * 5. Implement the function and test until you are confident on its correctness

 * 6. Repeat from 4 until all methods are implemented and tested

 * 7. Implement the destructor last; if there are still errors,

      then you know it is due to memory management

*/


template <typename T> // We will only be testing int and double

class Vector {

 private:

  size_t sz;
  T* buf;


 public:
    Vector(size_t newSz)
      : sz(newSz), buf(sz ? new T[sz]{} : nullptr) {}

    ~Vector() {delete[] buf;}

    Vector(initializer_list<T> L)
      :sz(L.size()), buf(sz ? new T[sz]: nullptr)
      {
        size_t i = 0;
        for (const T& x: L) buf[i++] = x;
      }


  Vector(const Vector & v) 
    :sz(v.sz), buf(sz ? new T[sz]: nullptr)
    {
      for(size_t i = 0; i < sz; ++i)
      {
        buf[i] = v.buf[i];
      }
    }


  size_t size() const 
  {
    return sz;
  }


  T & operator [] (const int i) 
  {
    if (i < 0 || static_cast<size_t>(i) >= sz)
      throw out_of_range("The index is out of bounds \n");
    return buf[i];
  }



  T operator [] (const int i) const 
  {
    if (i < 0 || static_cast<size_t>(i) >= sz)
      throw out_of_range("The index is out of bounds \n");
    return buf[i];
  }

 


  T operator * (const Vector & v) const 
  {
    if(sz == 0 || v.sz == 0) return T{};

    const size_t temp = min(sz, v.sz);

    T return_value{};

    for(size_t i = 0; i < temp; ++i)
    {
      return_value += buf[i] * v.buf[i];
    }
    return return_value;
  }



  Vector operator + (const Vector & v) const 
  {
    const size_t temp = max(sz, v.sz);

    Vector return_list(temp);

    const size_t share_length = min(sz, v.sz);

    for(size_t i = 0; i < share_length; ++i)
    {
      return_list.buf[i] = buf[i] + v.buf[i];
    }

    if(sz < v.sz)
    {
      for (size_t i = share_length; i < temp; ++i) return_list.buf[i] = v.buf[i];
    }
    else if (sz > v.sz)
    {
      for(size_t i  = share_length; i < temp; ++i) return_list.buf[i] = buf[i];
    }
    return return_list;

  }


  const Vector & operator = (const Vector & v) 
  {
    if (this == &v) return *this;

    T* newbuf = (v.sz ? new T[v.sz]: nullptr);
    for(size_t i = 0; i < v.sz; ++i) 
    {
      newbuf[i] = v.buf[i];
    }
    delete [] buf;
    buf = newbuf;
    sz = v.sz;
    return *this;
  }


  bool operator == (const Vector & v) const 
  {
    if (v.sz != sz) return false;
    for (size_t i = 0; i < sz; ++i)
    {
      if(!(buf[i] == v.buf[i])) return false;
    }
    return true;
  }



  bool operator != (const Vector & v) const 
  {
    return !(*this == v);
  }


  inline friend Vector operator * (const int scale, const Vector & v)
  {
    Vector return_list(v.sz);
    for(size_t i = 0; i < v.sz; ++i) return_list.buf[i] = static_cast<T>(scale) * v.buf[i];
    return return_list;
  }


  inline friend Vector operator + (const int adder, const Vector & v)
  {
    Vector return_list(v.sz);
    for (size_t i = 0; i < v.sz; ++i) return_list.buf[i] = static_cast<T>(adder) + v.buf[i];
    return return_list;
  }


  /**

   * Allows the << operator to correctly print out the vector.

   * ex: cout << V2; -> (v[0], v[1], v[2], ... v[sz-1])

   * @param o ostream to print the elems of the array, usage is o << thingToPrint;

   * @param v vector that will be printed out

   * @return the ostream passed in

  */

  inline friend ostream& operator << (ostream & o, const Vector & v)
  {
    o << "(";
    for (size_t i = 0; i < v.sz; ++i)
    {
      o << v.buf[i];
      if(i+1 < v.sz) o << ", ";
    }
    o << ")";
    return o;
  }

 

};

#endif