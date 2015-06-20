package ximple.b2c.dao;

import com.mchange.v2.c3p0.*;
import java.beans.PropertyVetoException;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;
import javax.sql.DataSource;
import ximple.b2c.util.ConfigLoader;
import static ximple.b2c.util.Log.log;

public class C3Pool {

    private ComboPooledDataSource cds = null;
    private DataSource ds = null;
    private static volatile C3Pool instance;

    public static C3Pool getInstance() {
        if (instance == null) {
            synchronized (C3Pool.class) {
                if (instance == null) {
                    instance = new C3Pool();
                }
            }
        }

        return instance;
    }

    private C3Pool() {

        if (ds == null) {
            try {
                Properties props = ConfigLoader.getProperties();
                String driver = props.getProperty("driver");
                String url = props.getProperty("url");
                String user = props.getProperty("user");
                String password = props.getProperty("pwd");
                
                int initPoolSize = 3;
                int minPoolSize = 3;
                int maxPoolSize = 6;
                int acquireIncrement = 1;
                
                int maxIdleTimeExcessConnections = 500;
                int checkoutTimeout = 2000;
                
                try{
                    initPoolSize = Integer.parseInt(props.getProperty("initPoolSize") );
                    minPoolSize = Integer.parseInt(props.getProperty("minPoolSize") );
                    maxPoolSize = Integer.parseInt(props.getProperty("maxPoolSize") );
                    maxIdleTimeExcessConnections = Integer.parseInt(props.getProperty("maxIdleTimeExcessConnections") );
                    checkoutTimeout = Integer.parseInt(props.getProperty("checkoutTimeout") );
                }catch(Exception e){
                    log.error(e);
                }
                
                

                cds = new ComboPooledDataSource();

                cds.setDriverClass(driver);
                cds.setJdbcUrl(url);
                cds.setUser(user);
                cds.setPassword(password);

                cds.setInitialPoolSize(initPoolSize);
                cds.setMinPoolSize(minPoolSize);
                cds.setMaxPoolSize(maxPoolSize);
                cds.setAcquireIncrement(acquireIncrement);
                
                

                cds.setMaxIdleTimeExcessConnections(maxIdleTimeExcessConnections);
                cds.setCheckoutTimeout(checkoutTimeout);
                
                cds.setDebugUnreturnedConnectionStackTraces(true);
                
                cds.setTestConnectionOnCheckin(false);
                cds.setTestConnectionOnCheckout(false);
                
                cds.setDebugUnreturnedConnectionStackTraces(false);

                ds = cds;

            } catch (PropertyVetoException exc) {
                log.error(exc.toString());
            }
        }
    }

    
    public Connection getConnection() throws SQLException {
        return ds.getConnection();
    }

    
    public void deleteInstance() {
        try {
            if (cds != null) {
                //cds.hardReset();
                cds.close();
                DataSources.destroy(cds);
            }
            cds = null;
            ds = null;
        } catch (SQLException se) {
            log.error(se);
        }
        instance = null;
        log.debug("Shuting down c3pool");
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        log.debug("C3Pool finalized");
    }

    
    
}
