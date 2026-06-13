import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;


public class FileIOStreamExample{
    public static void main(String[] args) {
        try {
            File inFile = new File("file.txt");
            File outFile = new File("file_copy.txt");
            FileInputStream fis = new FileInputStream(inFile);
            FileOutputStream fos = new FileOutputStream(outFile);
            int c;
            while((c = fis.read()) != -1){
                fos.write(c);
            }
            fis.close();
            fos.close();
        } catch (FileNotFoundException  e) {
            System.out.println("FileStreamsTest:" + e);
        } catch (IOException e){
            System.err.println("FileStreamTest:" + e);
        }
    }
}