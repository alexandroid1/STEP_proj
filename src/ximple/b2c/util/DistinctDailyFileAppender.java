
package ximple.b2c.util;


import java.io.File;
import java.util.Calendar;
import java.util.Date;


import org.apache.log4j.FileAppender;
import org.apache.log4j.spi.LoggingEvent;

/**
 * Based on biz.minaret.log4j.DatedFileAppender, decompiled with JAD, revised to
 * use optional hours.
 */
public class DistinctDailyFileAppender extends FileAppender {

    public static final String DEFAULT_DIRECTORY = "logs";
    public static final String DEFAULT_SUFFIX = ".log";
    public static final String DEFAULT_PREFIX = "b2c.";

    private String directory = DEFAULT_DIRECTORY;
    private String prefix = DEFAULT_PREFIX;
    private String suffix = DEFAULT_SUFFIX;
    private File currentPath = null;
    private Calendar currentCalendar = null;
    private long nextTime = 0l;
    private boolean hourly = false;

    /**
     * Constructor.
     */
    public DistinctDailyFileAppender() {
    }

    /**
     * This method is automatically called once by the system, immediately after
     * all properties are set, prior to release.
     */
    @Override
    public void activateOptions() {

        currentPath = new File(directory);
        if (!currentPath.isAbsolute()) {
            errorHandler.error("Directory failure for appender [" + name + "] : " + directory);
            return;
        }

        currentPath.mkdirs();

        // We can write; initialize calendar
        if (currentPath.canWrite()) {
            currentCalendar = Calendar.getInstance();
        } else {
            errorHandler.error("Cannot write for appender [" + name + "] : " + directory);
            return;
        }
    }

    /**
     * This is called, synchronized by parent.
     */
    @Override
    public void append(LoggingEvent event) {

        if (layout == null) {
            errorHandler.error("No layout set for appender [" + name + "].");
            return;
        }

        if (currentCalendar == null) {
            errorHandler.error("Improper initialization for appender [" + name + "].");
            return;
        }

        long nowTime = System.currentTimeMillis();
        if (nowTime >= nextTime) {
            currentCalendar.setTime(new Date(nowTime));
            String timestamp = generateTimestamp(currentCalendar);
            nextCalendar(currentCalendar);
            nextTime = currentCalendar.getTime().getTime();
            File file = new File(currentPath, prefix + timestamp + suffix);
            fileName = file.getAbsolutePath();
            super.activateOptions();
        }

        if (super.qw == null) {

            errorHandler.error("No output stream or file set for the appender named [" + name + "].");
            return;

        } else {

            subAppend(event);
            return;

        }
    }

    protected String generateTimestamp(Calendar calendar) {

        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH) + 1;
        int day = calendar.get(Calendar.DAY_OF_MONTH);
        int hour = calendar.get(Calendar.HOUR_OF_DAY);
        int minutes = calendar.get(Calendar.MINUTE);
        int seconds = calendar.get(Calendar.SECOND);

        StringBuffer buffer = new StringBuffer();

        if (year < 1000) {
            buffer.append('0');
            if (year < 100) {
                buffer.append('0');
                if (year < 10) {
                    buffer.append('0');
                }
            }
        }
        buffer.append(Integer.toString(year));
        buffer.append('-');

        if (month < 10) {
            buffer.append('0');
        }
        buffer.append(Integer.toString(month));
        buffer.append('-');

        if (day < 10) {
            buffer.append('0');
        }
        buffer.append(Integer.toString(day));
        buffer.append('_');

        if (hour < 10) {
            buffer.append('0');
        }
        buffer.append(Integer.toString(hour));

        if (minutes < 10) {
            buffer.append('0');
        }
        buffer.append(Integer.toString(minutes));

        if (seconds < 10) {
            buffer.append('0');
        }
        buffer.append(Integer.toString(seconds));

        return buffer.toString();
    }

    protected void nextCalendar(Calendar calendar) {
        int i = calendar.get(Calendar.YEAR);
        int j = calendar.get(Calendar.MONTH);

        if (hourly) {
            int k = calendar.get(Calendar.DAY_OF_MONTH);
            int l = calendar.get(Calendar.HOUR_OF_DAY) + 1;
            calendar.clear();
            calendar.set(i, j, k, l, 0);
        } else {
            int k = calendar.get(Calendar.DAY_OF_MONTH) + 1;
            calendar.clear();
            calendar.set(i, j, k);
        }
    }

    public String getDirectory() {
        return directory;
    }

    public void setDirectory(String directory) {
        if (directory == null || directory.length() == 0) {
            this.directory = "."; // Set to here
        } else {
            this.directory = directory;
        }
    }

    public String getPrefix() {
        return prefix;
    }

    public void setPrefix(String prefix) {
        if (prefix == null) {
            this.prefix = DEFAULT_PREFIX; // Set to default
        } else {
            this.prefix = prefix;
        }
    }

    public String getSuffix() {
        return suffix;
    }

    public void setSuffix(String suffix) {
        if (suffix == null) {
            this.suffix = ""; // Set to empty, not default
        } else {
            this.suffix = suffix;
        }
    }

    public void setHourly(boolean hourly) {
        this.hourly = hourly;
    }

    public boolean isHourly() {
        return this.hourly;
    }
}

