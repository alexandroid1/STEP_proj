
package ximple.b2c.util;

import com.google.gson.*;
import java.lang.reflect.Type;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import static ximple.b2c.util.Log.log;

/**
 *
 * @author admin
 */
public class Responser {

    public static enum MsgType{
        ChatMessage,
        ChangedStatusOfUser,
        NewUser,
        GroupChatMessage,
        Logedout,
        Error,
        ListOfUsers,
        Empty   // for ie
    }

    public static class Resp {
        public MsgType type;
        public Object data;
        
        public Resp(MsgType type, Object data){
            this.type = type;
            this.data = data;
        }
    }
    
    static final GsonBuilder gsonb;
    static final Gson gson;
    static {
        gsonb = new GsonBuilder();
        DateSerializer ds = new DateSerializer();
        gsonb.registerTypeAdapter(Date.class, ds);
        gson = gsonb.serializeNulls()
                //.setPrettyPrinting()
                .create();
    }


    public static String success(MsgType type, Object obj) {
        Resp r = new Resp(type, obj);
        String jsonOutput = gson.toJson(r);
        return jsonOutput+ "      \n";
    }

    public static String error(Object obj) {
        if (obj instanceof Exception) {
            obj = ((Exception) obj).getMessage();
        }
        Map<String, String> m = new HashMap();
        m.put("error", obj + "");

        String jsonOutput = gson.toJson(m);
        return jsonOutput+ "      \n";
    }
    
    public static String out(Object obj) {
        String jsonOutput = gson.toJson(obj);
        return jsonOutput+ "      \n";
    }

}


class DateSerializer implements JsonSerializer<Object> {
    public JsonElement serialize(Date date, Type typeOfT, JsonSerializationContext context) {
        return new JsonPrimitive(date.getTime());
    }

    @Override
    public JsonElement serialize(Object arg0, Type arg1,
            JsonSerializationContext arg2) {

        Date date = (Date) arg0;
        return new JsonPrimitive(date.getTime() + "");
    }
}

