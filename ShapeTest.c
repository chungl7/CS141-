#include <stdlib.h>
#include <iostream>
#include <cstdlib>
using namespace std;


typedef double (*double_method_type)(void *);
typedef void (*void_method_type)(void *);
typedef std::string (*string_method_type)(void *);

typedef union{
    double_method_type double_method;
    void_method_type void_method;
    string_method_type string_method;
} VirtualTableEntry;

typedef VirtualTableEntry * VTableType;


#define AREA_INDEX 0
#define DRAW_INDEX 1
#define DIMSTR_INDEX 2

#define PI 3.14159

struct Shape
{
    VTableType VPointer;
    std::string name;
};

static inline void Shape_print(Shape* _this)
{
    string dims = _this->VPointer[DIMSTR_INDEX].string_method(_this);
    double a = _this->VPointer[AREA_INDEX].double_method(_this);
    cout << _this->name << "(" << dims << ") : " << a << "\n";
}

static Shape* Shape_Shape(Shape* _this, const string& newName)
{
    _this->name = newName;
    return _this;
}


struct Circle
{
    VTableType VPointer;
    string name;
    double radius;
};

static double Circle_area(Circle* _this)
{
    return PI * _this->radius * _this->radius;
}

static void Circle_draw(void* p)
{
    cout << "  ***  \n"
            " *   * \n"
            "  ***  \n";
}

static string Circle_dimensionString(Circle* _this)
{
    return to_string((int)_this->radius);
}

VirtualTableEntry Circle_VTable [] = 
{
    {.double_method=(double_method_type)Circle_area},
    {.void_method=(void_method_type) Circle_draw},
    {.string_method=(string_method_type)Circle_dimensionString}
};

Circle * Circle_Circle(Circle * _this, const string newName, double newRadius)
{
    Shape_Shape((Shape*) _this, newName);
    _this->VPointer = Circle_VTable;
    _this->name = newName;
    _this->radius = newRadius;
    return _this;
}


struct Square
{
    VTableType VPointer;
    std::string name;
    double length;
};

static double Square_area(Square* _this)
{
    return _this->length * _this->length;
}

static void Square_draw(void * p)
{
    cout << "*** \n"
            "* * \n"
            "*** \n";
}

static string Square_dimensionString(Square* _this)
{
    return to_string((int)_this->length);
}

static VirtualTableEntry Square_VTable[] = 
{
    {.double_method= (double_method_type) Square_area},
    {.void_method= (void_method_type) Square_draw},
    {.string_method= (string_method_type) Square_dimensionString}
};

static Square* Square_Square(Square* _this, const string newName, double newLength)
{
    Shape_Shape((Shape*)_this, newName);
    _this->VPointer = Square_VTable;
    _this->name = newName;
    _this->length = newLength;
    return _this;
}


struct Rectangle
{
    Square base_class;
    double width, height;
};

static double Rectangle_area(Rectangle* _this)
{
    return _this->width * _this->height;
}

static void Rectangle_draw(void * p)
{
    cout << "***** \n"
            "*   * \n"
            "*   * \n"
            "*   * \n"
            "*   * \n"
            "*   * \n"
            "***** \n";
}

static string Rectangle_dimension(Rectangle* _this)
{
    return to_string((int)_this->width) + ", " + to_string((int)_this->height);
}

static VirtualTableEntry Rectangle_VTable[] = 
{
    {.double_method = (double_method_type) Rectangle_area},
    {.void_method = (void_method_type) Rectangle_draw},
    {.string_method = (string_method_type) Rectangle_dimension} 
};

static Rectangle* Rectangle_Rectangle(Rectangle*_this, const string newName, double newWidth, double newHeight)
{
    Square_Square(&_this->base_class, newName, newHeight);
    _this->base_class.VPointer = Rectangle_VTable;
    _this->width = newWidth;
    _this->height = newHeight;
    return _this;
}


struct Triangle
{
    VTableType VPointer;
    string name;
    double base;
    double height;
};

static double Triangle_area(Triangle* _this)
{
    return 0.5 * _this->base * _this->height;
}

static void Triangle_draw(void * p)
{
    cout << "  *  \n"
            " * * \n"
            "***** \n";
}

static string Triangle_dimensionString(Triangle*_this)
{
    return to_string((int)_this->base) + ", " + to_string((int)_this->height);
}

static VirtualTableEntry Triangle_VTable[] = 
{
    {.double_method = (double_method_type) Triangle_area},
    {.void_method = (void_method_type) Triangle_draw},
    {.string_method = (string_method_type) Triangle_dimensionString}
};

static Triangle* Triangle_Triangle(Triangle* _this, const string newName, double newBase, double newHeight)
{
    Shape_Shape((Shape*)_this, newName);
    _this->VPointer = Triangle_VTable;
    _this->name = newName;
    _this->base = newBase;
    _this->height = newHeight;
    return _this;
}

static void printAll(Shape** arr, int n)
{
    for (int i = 0; i < n; ++i) Shape_print(arr[i]);
}

static void drawAll(Shape** arr, int n)
{
    for (int i = 0; i < n; ++i) arr[i]->VPointer[DRAW_INDEX].void_method(arr[i]);
}

static double totalArea(Shape** arr, int n)
{
    double s = 0.0;
    for (int i = 0; i < n; ++i)
        s += arr[i]->VPointer[AREA_INDEX].double_method(arr[i]);
    return s;
}

int main(int argc, char** argv)
{
    int value1 = atoi(argv[1]);
    int value2 = atoi(argv[2]);

    int value1_1 = value1-1;
    int value2_2 = value2-1;

    Triangle* t1 = Triangle_Triangle(new Triangle, "FirstTriangle", value1, value2);
    Triangle* t2 = Triangle_Triangle(new Triangle, "SecondTriangle", value1_1, value2_2);

    Circle* c1 = Circle_Circle(new Circle, "FirstCircle", value1);
    Circle* c2 = Circle_Circle(new Circle, "SecondCircle", value1_1);

    Square* s1 = Square_Square(new Square, "FirstSquare", value1);
    Square* s2 = Square_Square(new Square, "SecondSquare", value1_1);

    Rectangle* r1 = Rectangle_Rectangle(new Rectangle, "FirstRectangle", value1, value2);
    Rectangle* r2 = Rectangle_Rectangle(new Rectangle, "SecondRectangle", value1_1, value2_2);

    Shape* picture[] = 
    {
        (Shape*) t1, (Shape*) t2,
        (Shape*) c1, (Shape*) c2,
        (Shape*) s1, (Shape*) s2,
        (Shape*) &r1->base_class, (Shape*) &r2->base_class
    };

    int N = (int) (sizeof(picture)/sizeof(picture[0]));

    printAll(picture, (N));
    drawAll(picture, (N));
    cout << "Total : " << totalArea(picture, N) << "\n";
    return 0;
}