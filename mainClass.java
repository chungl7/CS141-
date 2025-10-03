abstract class Shape {
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

    public abstract void draw();

    public abstract String dimensionString();

    public void print()
    {
        System.out.println(name + "(" + dimensionString() + ") : " + area());
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

    public void draw()
    {
        System.out.println("   *****   ");
        System.out.println(" **     ** ");
        System.out.println("*         *");
        System.out.println("*         *");
        System.out.println("*         *");
        System.out.println(" **     ** ");
        System.out.println("   *****   ");
    }

    public String dimensionString()
    {
        return String.valueOf((int)radius);
    }
}

class Square extends Shape {
    protected double length;

    public Square(String name, double newLength)
    {
        super(name);
        length = newLength;
    }

    double area()
    {
        return length *length;
    }

    public void draw()
    {
        System.out.println("***");
        System.out.println("* *");
        System.out.println("***");
    }

    public String dimensionString()
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

    public void draw()
    {
        System.out.println("  *  ");
        System.out.println(" * * ");
        System.out.println("*****");
    }

    public String dimensionString()
    {
        return ((int)base) + ", " + ((int)height);
    }
}

class Rectangle extends Square{
    double width, height;

    public Rectangle(String name, double newWidth, double newHeight)
    {
        super(name, newHeight);
        this.width = newWidth;
    }

    double area()
    {
        return width * height;
    }

    public void draw()
    {
        System.out.println("*****");
        System.out.println("*   *");
        System.out.println("*   *");
        System.out.println("*****");
    }

    public String dimensionString()
    {
        return ((int)height) + ", "+ ((int)width);
    }
}

class ListNode {
    Shape info;
    ListNode next;
    ListNode (Shape info, ListNode next)
    {
        this.info = info;
        this.next = next;
    }
}

class Picture
{
    ListNode head;

    public Picture()
    {
        head = null;
    }

    public void add(Shape sh)
    {
        head = new ListNode(sh, head);
    }

    public void printAll()
    {
        for(ListNode i = head; i != null; i = i.next )
        {
            i.info.print();
        }
    }

    public void drawAll()
    {
        for(ListNode i = head; i != null; i = i.next)
        {
            i.info.draw();
        }
    }

    public double totalArea()
    {
        double total = 0.0;

        for(ListNode i = head; i != null; i = i.next)
        {
            total += i.info.area();
        }
        return total;
    }
}




class LinkedList {
    ListNode head;

    LinkedList(){
        head = null;
    }

    void add (Shape x)
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

public class mainClass
{
    public static void main(String[] args)
    {
        if(args.length < 2)
        {
            System.out.println("Insufficient Input");
            return;
        }
        int arg1, arg2;
        arg1 = Integer.parseInt(args[0]);
        arg2 = Integer.parseInt(args[1]);

        int arg1_2 = arg1 -1;
        int arg2_2 = arg2 -1;

        Picture example = new Picture();

        example.add(new Triangle("FirstTriangle", arg1, arg2));
        example.add(new Triangle("SecondTriangle", arg1_2, arg2_2));

        example.add(new Circle("FirstCircle", arg1));
        example.add(new Circle("SecondCircle", arg1_2));

        example.add(new Square("FirstSquare", arg1));
        example.add(new Square("SecondSquare", arg1_2));

        example.add(new Rectangle("FirstRectangle", arg1, arg2));
        example.add(new Rectangle("SecondRectangle", arg1_2, arg2_2));

        example.printAll();
        example.drawAll();
        System.out.println("Total : " + example.totalArea());

    }

    
}