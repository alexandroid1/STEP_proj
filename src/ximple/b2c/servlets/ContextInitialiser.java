
package ximple.b2c.servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
//import java.util.concurrent.Executors;
//import java.util.concurrent.ScheduledExecutorService;
import javax.servlet.AsyncContext;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import ximple.b2c.dao.UserDao;
import ximple.b2c.util.ConfigLoader;
import ximple.b2c.util.Log;
import static ximple.b2c.util.Log.log;


@WebListener
public class ContextInitialiser implements ServletContextListener {


    @Override
    public void contextInitialized(ServletContextEvent sce) {


        Log.initLog(sce.getServletContext().getRealPath("/log/"));

        ConfigLoader cl = new ConfigLoader(sce.getServletContext().getRealPath("/WEB-INF/config.properties"));

        // **************************
        // stick a new model into the application scope
        // **************************


    }


    @Override
    public void contextDestroyed(ServletContextEvent sce) {

    }
}

