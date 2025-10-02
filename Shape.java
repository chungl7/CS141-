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

    Circle(double newRadius) {super(); radius = newRadius;}

    double area() {return Pi * radius * radius;}

    void draw()
    {
        System.out.printf("");
    }
}

class Square extends Shape {
    ;
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