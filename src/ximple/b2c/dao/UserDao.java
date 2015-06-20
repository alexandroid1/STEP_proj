
package ximple.b2c.dao;

import java.util.*;
import java.sql.*;
import ximple.b2c.beans.*;
import ximple.b2c.util.Common;
import static ximple.b2c.util.Log.log;

/**
 *
 * @author admin
 */
public class UserDao extends AbstractDao {

    private static volatile UserDao instance;


    public static UserDao getInstance() {
        if (instance == null) {
            synchronized (UserDao.class) {
                if (instance == null) {
                    instance = new UserDao();
                }
            }
        }
        return instance;
    }


    public static void deleteInstance() {
        instance = null;
        log.info("Shutting down UserDao");
    }


    public List<User> getAllUsers(Tx... itx) throws Exception {
        List<User> users = null;
        Tx tx = null;
        Connection conn = null;
        CallableStatement stat = null;
        ResultSet set = null;
        try {
            tx = getTx(itx);
            conn = tx.conn;
//            String query = "{call GETUSER2(?, ?)}";
            String query = "{call GETUSER3()}";
            //stat = new ParamStatement(conn, query);
            stat = conn.prepareCall(query, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            //stat.setLong("SSID",1);
            //stat.setString("SSNAME", "t");
            set = stat.executeQuery();
            users = new ArrayList();

            while (set.next()) {
                User user = new User();// fillUser(set);
                user.setId(set.getLong(1));
                users.add(user);
            }

        } catch (SQLException se) {
            rollback(tx);
            throw se;
        } finally {
            close(set, stat, tx);
        }

        return users;
    }


    public User searchUser(long id, Tx... itx) throws Exception {
        User user = null;
        Tx tx = null;
        Connection conn = null;
        ParamStatement stat = null;
        ResultSet set = null;
        try {
            tx = getTx(itx);
            conn = tx.conn;
            String query = "SELECT * FROM CHATUSER WHERE CUUSERID = :id";
            stat = new ParamStatement(conn, query);
            stat.setLong("id", id);
            set = stat.executeQuery();
            while (set.next()) {
                user = fillUser(set);
            }

        } catch (SQLException se) {
            rollback(tx);
            throw se;
        } finally {
            close(set, stat, tx);
        }

        return user;
    }




    public User addUser(User newUser, Tx... itx) throws Exception {
        Tx tx = null;
        Connection conn = null;
        ParamStatement stat = null;
        User createdUser = null;
        int result = 0;
        int generatedUserId = -1;

        try {
            tx = getTx(itx);
            conn = tx.conn;
//            String query = "INSERT INTO user "
//                    + "(id, name, status ) "
//                    + "VALUES ( :id, :name, :status )";

            String query = "INSERT INTO CHATUSER "
                    + "(CUUSERID, CUSTATUS, CUNAME ) "
                    + "VALUES ( :id, :status, :name )";
            stat = new ParamStatement(conn, query, PreparedStatement.RETURN_GENERATED_KEYS);
            stat.setLong("id", newUser.getId());
            stat.setString("name", newUser.getName());
//            stat.setString("status", newUser.getStatus());

            result = stat.executeUpdate();

            ResultSet rset = stat.getGeneratedKeys();
            int rsetCount = 0;
            while (rset.next()) {
                rsetCount++;
                generatedUserId = rset.getInt(1);
                newUser.setId(generatedUserId);
            }
            close(rset);
            if(rsetCount>0){
                createdUser = this.searchUser(generatedUserId, tx);
            }else{
                createdUser = newUser;
            }
            
        } catch (SQLException se) {
            rollback(tx);
            throw se;
        } finally {
            close(stat, tx);
        }

        return createdUser;
    }


    public int updateUser(User regUser, Tx... itx) throws Exception {
        int result = 0;
        Tx tx = null;
        Connection conn = null;
        ParamStatement stat = null;
        try {
            tx = getTx(itx);
            conn = tx.conn;
//            String query = "UPDATE  user  SET "
//                    + " name = :name,"
//                    + " status = :status"
//                    + " WHERE id = :id";
            String query =  "UPDATE  CHATUSER  SET "
                    + " CUNAME = :name,"
                    + " CUSTATUS = :status"
                    + " WHERE CUUSERID = :id";
            stat = new ParamStatement(conn, query);

            stat.setString("name", regUser.getName());
//            stat.setString("status", regUser.getStatus());
            stat.setLong("id", regUser.getId());

            result = stat.executeUpdate();

        } catch (SQLException se) {
            rollback(tx);
            throw se;
        } finally {
            close(stat, tx);
        }

        return result;
    }


    public int deleteUser(User regUser, Tx... itx) throws Exception {
        int result = 0;
        Tx tx = null;
        Connection conn = null;
        ParamStatement stat = null;
        try {
            tx = getTx(itx);
            conn = tx.conn;
//            String query = "DELETE FROM user "
//                    + " WHERE id=:id";
            String query ="DELETE FROM CHATUSER  WHERE CUUSERID = :id";

            stat = new ParamStatement(conn, query);
            stat.setLong("id", regUser.getId());

            result = stat.executeUpdate();

        } catch (SQLException se) {
            rollback(tx);
            throw se;
        } finally {
            close(stat, tx);
        }

        return result;
    }




    private User fillUser(ResultSet set) throws SQLException {
        User user = new User();
//        user.setId(set.getInt("id"));
//        user.setName(set.getString("name"));
//        user.setStatus(set.getString("status"));
        user.setId(set.getLong("CUUSERID"));
        user.setName(set.getString("CUNAME"));
//        user.setStatus(set.getString("CUSTATUS"));


        return user;
    }

}

