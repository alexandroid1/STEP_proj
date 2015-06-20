
package ximple.b2c.util;

import java.io.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.apache.log4j.*;
import org.apache.log4j.Logger;

public class Log {

    public static Logger log;

    public static void initLog(String pathToLogFile) {
        String baseDir = System.getProperty("catalina.base");
        if(baseDir == null){
            baseDir = System.getProperty("user.install.root");
        }
        String catLogPath = baseDir + File.separator + "logs" + File.separator;
        Logger root = Logger.getRootLogger();
        Layout layout = new PatternLayout("%p [%t] (%F:%L) - %m%n");
        root.setLevel(Level.INFO);

        DistinctDailyFileAppender rollingAppender;
        try {
            rollingAppender = new DistinctDailyFileAppender();
            rollingAppender.setAppend(true);
            //DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            rollingAppender.setDirectory(catLogPath);
            rollingAppender.setLayout(layout);
            rollingAppender.activateOptions();
            root.addAppender(rollingAppender);
        } catch (Exception exc) {
            exc.printStackTrace();
        }

        //root.addAppender(new ConsoleAppender(layout, ConsoleAppender.SYSTEM_OUT));

        log = root;
    }



}

