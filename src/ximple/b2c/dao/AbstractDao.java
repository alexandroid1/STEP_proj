
package ximple.b2c.dao;

import java.sql.*;
import static ximple.b2c.util.Log.log;

/**
 *
 * @author admin
 */
public abstract class AbstractDao
{

    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        log.debug("Dao finalized");
    }


    protected static C3Pool pool = C3Pool.getInstance();


    private static Connection getConnection(Tx iTx) throws SQLException {
        Connection conn = null;
        if (iTx == null) {
            conn = pool.getConnection();
            conn.setAutoCommit(false);
        } else {
            conn = iTx.conn;
        }
        return conn;
    }


    protected static void close(Object... resources) {
        try {
            for (Object resource : resources) {
                if (resource instanceof ResultSet) {
                    ((ResultSet) resource).close();
                    continue;
                }
                if (resource instanceof Statement) {
                    ((Statement) resource).close();
                    continue;
                }
                if (resource instanceof PreparedStatement) {
                    ((PreparedStatement) resource).close();
                    continue;
                }
                if (resource instanceof Connection) {
                    throw new IllegalStateException("might not close connection, must closing Tx.");
                }
                if (resource instanceof Tx) {
                    Tx tx = (Tx) resource;
                    tx.levelCount--;
                    if (tx.levelCount == 0) {
                        Connection conn = tx.conn;

                        if (!conn.isClosed()) {
                            conn.commit();
                        }
                        conn.setAutoCommit(true);
                        conn.close();
                    } else if (tx.levelCount < 0) {
                        throw new IllegalStateException("Error tx.levelCount < 0");
                    }


                }

            }
        } catch (SQLException sExc) {
            log.error(sExc.toString());
        }
    }


    public static class Tx
    {
        public Connection conn;
        public int levelCount;
        public Tx() throws SQLException {
            this.conn = getConnection(null);
            this.levelCount = 0;
        }
        
        public void rollback() throws SQLException{
            if(this.conn!=null){
                conn.rollback();
            }
        }

    }


    public static Tx getTx(Tx[] tx) throws SQLException {
        Tx returnedTx = null;
        if (tx.length > 0) {
            returnedTx = tx[0];
        } else {
            returnedTx = new Tx();
        }
        returnedTx.levelCount++;
        return returnedTx;
    }
    
    protected static void rollback(Tx tx){
        try{
            if(tx!=null){
                Connection conn = tx.conn;
                if(!conn.isClosed()){
                    tx.rollback();
                }
            }
        }catch(SQLException se){
            log.error(se);
        }
    }


}
