
package ximple.b2c.util;

import java.util.List;

/**
 *
 * @author admin
 */
public class Common
{
    public static String join(String join, Object... strings) {
        if (strings == null || strings.length == 0) {
            return "";
        } else if (strings.length == 1) {
            return strings[0]+"";
        } else {
            StringBuilder sb = new StringBuilder();
            sb.append(strings[0]);
            for (int i = 1; i < strings.length; i++) {
                sb.append(join).append(strings[i]);
            }
            return sb.toString();
        }
    }

    public static String joinList(String join, List<? extends Object> stringsList) {
        if (stringsList == null || stringsList.isEmpty() ) {
            return "";
        } else if (stringsList.size() == 1) {
            return stringsList.get(0)+"";
        } else {
            StringBuilder sb = new StringBuilder();
            sb.append(stringsList.get(0));
            for (int i = 1; i < stringsList.size(); i++) {
                sb.append(join).append(stringsList.get(i));
            }
            return sb.toString();
        }
    }

}
