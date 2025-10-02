public abstract class Shape {
    private final String name;
    
    Shape (String name)
    {
        this.name = name;
    }
    double area()
    { return 0.0;}

    public String getName()
    {
        return name;
    }

    abstract void draw();

    abstract String dimensionString();

    public void print()
    {
        System.out.printf(name + "(" + dimensionString() + ") : " + area());
    }
}

class Circle extends Shape {
    double radius;
    static final double Pi = 3.14;

    public Circle(String name, double newRadius) 
    {
        super(name); 
        radius = newRadius;
    }

    double area() 
    {
        return Pi * radius * radius;
    }

    void draw()
    {
        System.out.println("   *****   ");
        System.out.println(" **     ** ");
        System.out.println("*         *");
        System.out.println("*         *");
        System.out.println("*         *");
        System.out.println(" **     ** ");
        System.out.println("   *****   ");
    }

    String dimensionString()
    {
        return String.valueOf((int)radius);
    }
}

class Square extends Shape {
    double length;

    public Square(String name, double newLength)
    {
        super(name);
        length = newLength;
    }

    double area()
    {
        return length *length;
    }

    void draw()
    {
        System.out.println("***");
        System.out.println("* *");
        System.out.println("***");
    }

    String dimensionString()
    {
        return String.valueOf((int)length);
    }
}

class Triangle extends Shape {
    double base, height;
    
    public Triangle(String name, double newBase, double newHeight)
    {
        super(name);
        base = newBase;
        height = newHeight;
    }

    double area()
    {
        return 0.5 * base * height;
    }

    void draw()
    {
        System.out.println("  *  ");
        System.out.println(" * * ");
        System.out.println("*****");
    }

    String dimensionString()
    {
        return ((int)base) + ", " + ((int)height);
    }
}

class Rectangle extends Square{
    double width, height;

    public Rectangle(String name, double newWidth, double newHeight)
    {
        super(name, newHeight);
        width = newWidth;
    }

    double area()
    {
        return width * height;
    }

    void draw()
    {
        System.out.println("*****");
        System.out.println("*   *");
        System.out.println("*   *");
        System.out.println("*****");
    }

    String dimensionString()
    {
        return ((int)height) + ", "+ ((int)width);
    }
}



class ListNode {
    String info;
    ListNode next;
    ListNode (String info, ListNode next)
    {
        this.info = info;
        this.next = next;
    }
}

class LinkedList {
    ListNode head;

    LinkedList(){
        head = null;
    }

    void add (String x)
    {
        head = new ListNode(x, head);
    }

    int length()
    {
        int len = 0;
        for(ListNode p = head; p != null; p = p.next)
            ++len;
        return len;
    }

    boolean isEmpty()
    {
        return head == null;
    }

    public String toString()
    {
        String result = "";
        for(ListNode p = head; p != null; p = p.next)
            result += p.info.toString() + " ";
        return result;
    }
}