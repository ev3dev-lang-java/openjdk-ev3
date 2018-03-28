package jshellhack;

import java.nio.file.*;
import java.lang.*;

import static java.nio.file.StandardOpenOption.CREATE;
import static java.nio.file.StandardOpenOption.WRITE;
import static java.nio.file.StandardOpenOption.TRUNCATE_EXISTING;

public class DumpPort {

    public static void main(String[] args) throws Exception {
        StringBuilder build = new StringBuilder();
        build.append(args[0]);
        build.append("\n");
        OpenOption[] opts = new OpenOption[] { CREATE, WRITE, TRUNCATE_EXISTING };
        Files.write(Paths.get("/tmp/jshellargs"), build.toString().getBytes(), opts);
    }
}
