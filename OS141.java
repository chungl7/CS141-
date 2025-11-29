import java.io.*;
import java.util.*;

class Disk {
    static final int NUM_SECTORS = 2048;
    static final int DISK_DELAY = 80;

    StringBuffer sectors[] = new StringBuffer[NUM_SECTORS];

    public Disk(){
        for(int i = 0; i < NUM_SECTORS; i++){
            sectors[i] = new StringBuffer();
        }
    }

    void write(int sector, StringBuffer data) {
        try {
            Thread.sleep(DISK_DELAY);
        } catch (InterruptedException e){

        }
        sectors[sector].setLength(0);
        sectors[sector].append(data);
    }

    void read(int sector, StringBuffer data)
    {
        try {
            Thread.sleep(DISK_DELAY);
        } catch (InterruptedException e) {

        }
        data.setLength(0);
        data.append(sectors[sector]);
    }

}


class Printer {
    static final int PRINT_DELAY = 275;
    private int iden;
    private BufferedWriter output;

    Printer(int iden) {
        this.iden = iden;
        try {
            output = new BufferedWriter(new FileWriter("PRINTER" + iden));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
    void print(StringBuffer data)
    {
        try {
            Thread.sleep(PRINT_DELAY);
            output.write(data.toString());
            output.newLine();
            output.flush();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}

class FileInfo{
    int diskNumber;
    int startingSector;
    int fileLength;
}

class DirectoryManager {
    private Hashtable<String, FileInfo> T = 
        new Hashtable<String, FileInfo>();

    void enter(StringBuffer fileName, FileInfo file) {
        T.put(fileName.toString(),file);
    }

    FileInfo lookup(StringBuffer filename) {
        return T.get(filename.toString());
    }
}

class ResourceManager {
    boolean isFree[];
    ResourceManager(int numberOfItems) {
        isFree = new boolean[numberOfItems];
        for(int i = 0; i < isFree.length; ++i)
            isFree[i] = true;
    }

    synchronized int request() {
        while(true){
            for(int i = 0; i < isFree.length; ++i)
                    if(isFree[i]) {
                        isFree[i] = false;
                        return i;
                    }
                try {
                    this.wait();
                } catch (InterruptedException e){

                }
        }
    }
    synchronized void release(int index) {
        isFree[index] = true;
        this.notify();
    }
}

class DiskManager extends ResourceManager {
    private int[] freeSector;

    DiskManager(Disk[] disk) {
        super(disk.length);
        freeSector = new int[disk.length];
        for (int i = 0; i < disk.length; i++) {
            freeSector[i] = 0;
        }
    }

    synchronized int allocateSectors(int disknum, int filelen) {
        int start = freeSector[disknum];
        freeSector[disknum] += filelen;
        return start;
    }
}

class PrinterManager extends ResourceManager {
    PrinterManager(Printer[] printers) {
        super(printers.length);
    }
}

class UserThread extends Thread {
    String fileName;
    String line;

    static Disk[] disks;
    static Printer[] printers;
    static DiskManager diskManager;
    static PrinterManager printerManager;
    static DirectoryManager directoryManager;

    private ArrayList<PrintJobThread> printJobs = new ArrayList<>();

    UserThread(String fileName) {
        this.fileName = fileName;
    }

    public void run()
    {
        processUserCommands(fileName);
        for (PrintJobThread job: printJobs) {
            try {
                job.join();
            } catch (InterruptedException e){
                
            }
        }
    }

    private void processUserCommands(String fileName) {
        try (BufferedReader buffer = new BufferedReader(new FileReader(fileName))) {
            String line;
            while ((line = buffer.readLine()) != null) {
                if(line.startsWith(".save")) {
                    String[] parts = line.split("\\s+");
                    if (parts.length < 2) continue;
                    StringBuffer name = new StringBuffer(parts[1]);

                    ArrayList<StringBuffer> data = new ArrayList<>();
                    while ((line = buffer.readLine()) != null && !line.equals(".end")) {
                        data.add(new StringBuffer(line));
                    }

                    int fileLength = data.size();
                    if (fileLength == 0) {
                        FileInfo empty = new FileInfo();
                        empty.diskNumber = 0;
                        empty.startingSector = 0;
                        empty.fileLength = 0;
                        directoryManager.enter(name, empty);
                        continue;
                    }

                    int diskNum = diskManager.request();
                    try {
                        int start = diskManager.allocateSectors(diskNum, fileLength);
                        Disk d = disks[diskNum];

                        for(int i = 0; i < fileLength; i++) {
                            d.write(start + i, data.get(i));
                        }

                        FileInfo info = new FileInfo();
                        info.diskNumber = diskNum;
                        info.startingSector = start;
                        info.fileLength = fileLength;
                        directoryManager.enter(name, info);

                    } finally {
                        diskManager.release(diskNum);
                    }
                }
                else if(line.startsWith(".print")) {
                    String[] part = line.split("\\s+");
                    if (part.length < 2) continue;

                    StringBuffer name = new StringBuffer(part[1]);
                    FileInfo info = directoryManager.lookup(name);
                    if (info != null) {
                        PrintJobThread job = new PrintJobThread(info);
                        job.start();
                    }
                }
            }
        } catch (IOException e) {

        }
    }

}

class PrintJobThread extends Thread {
    private FileInfo info;

    PrintJobThread(FileInfo info) {
        this.info = info;
    }

    public void run() {
        int printerIndex = UserThread.printerManager.request();
        try {
            Printer print = UserThread.printers[printerIndex];
            Disk dis =UserThread.disks[info.diskNumber];

            StringBuffer buffer = new StringBuffer();
            for(int i = 0; i < info.fileLength; i++){
                dis.read(info.startingSector + i, buffer);
                print.print(buffer);
            }
        } finally {
            UserThread.printerManager.release(printerIndex);
        }
    }
}

public class OS141 {
    int NUM_USERS = 4, NUM_DISKS = 2, NUM_PRINTERS = 3;
    String userFileNames[];
    UserThread users[];
    Disk disks[];
    Printer printers[];
    DiskManager diskManager;
    PrinterManager printerManager;
    DirectoryManager directoryManager;


    void configure(String argv[]) {
        if (argv != null && argv.length >= 3) {
            NUM_USERS = passArg(argv[0], NUM_USERS);
            NUM_DISKS = passArg(argv[1], NUM_DISKS);
            NUM_PRINTERS = passArg(argv[2], NUM_PRINTERS);
        }
        userFileNames = new String[NUM_USERS];
        for (int i = 0; i < NUM_USERS; i++) {
            userFileNames[i] = "USER" + i;
        }

    }

    private int passArg(String str, int defaultVal) {
        if (str == null || str.length() == 0) return defaultVal;
        if (str.charAt(0) == '-') str = str.substring(1);
        try {
            return Integer.parseInt(str);
        } catch (NumberFormatException e)
        {
            return defaultVal;
        }
    }

    OS141(String [] argv) {
        configure(argv);

        disks = new Disk[NUM_DISKS];
        for (int i = 0; i < NUM_DISKS; ++i)
            disks[i] = new Disk();

        printers = new Printer[NUM_PRINTERS];
        for (int i = 0; i < NUM_PRINTERS; ++i)
            printers[i] = new Printer(i);

        directoryManager = new DirectoryManager();
        diskManager = new DiskManager(disks);
        printerManager = new PrinterManager(printers);

        UserThread.disks = disks;
        UserThread.printers = printers;
        UserThread.diskManager = diskManager;
        UserThread.printerManager = printerManager;
        UserThread.directoryManager = directoryManager;
        
        users = new UserThread[NUM_USERS];
        for(int i = 0; i < NUM_USERS; i++) {
            users[i] = new UserThread(userFileNames[i]); 
        }
    }

    void startUserThreads()
    {for (int i=0; i < NUM_USERS; i++) users[i].start();}

    void joinUserThreads() {
        for(int i=0; i < NUM_USERS; i++) {
            try {
                users[i].join();
            } catch (InterruptedException e) {

            }
        }
            
    }

    private static OS141 instance;

    static OS141 instance(String[] argv) {
        if(instance == null) instance = new OS141(argv);
        return instance;
    }

    public static void main(String[] args)
    {
        OS141 os = instance(args);
        os.startUserThreads();
        os.joinUserThreads();
    }
}