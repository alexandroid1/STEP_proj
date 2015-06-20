package ximple.b2c.util;

import java.io.*;
import java.util.*;
import static ximple.b2c.util.Log.log;


public class ConfigLoader {
    

    private static Properties props;

    public ConfigLoader(String path) {
        Properties lprops = new Properties();
        try {
            Reader in = new FileReader(path);
            lprops.load(in);
            in.close();
        } catch (IOException exc) {
            log.error(exc.toString());
        }

        props = lprops;
        lprops = null;
    }

    public static Properties getProperties() {
        return props;
    }

    public void shutdown() {
        props = null;
    }

}
