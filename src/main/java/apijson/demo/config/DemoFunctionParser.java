package apijson.demo.config;


import apijson.*;
import apijson.demo.controller.DemoController;
import apijson.demo.model.Todo;
import apijson.demo.model.User;
import apijson.framework.APIJSONConstant;
import apijson.framework.APIJSONFunctionParser;
import apijson.framework.APIJSONParser;
import apijson.framework.APIJSONSQLExecutor;
import apijson.orm.Parser;
import apijson.orm.SQLExecutor;
import apijson.orm.exception.ConditionErrorException;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;
import com.alibaba.fastjson.serializer.SerializerFeature;

import javax.servlet.http.HttpSession;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.*;

import static apijson.RequestMethod.GET;
import static apijson.RequestMethod.HEAD;

public class DemoFunctionParser extends APIJSONFunctionParser {

    public DemoFunctionParser() {
        this(null, null, 0, null, null);
    }
    // 展示在远程函数内部可以用 this 拿到的东西
    public DemoFunctionParser(RequestMethod method, String tag, int version, JSONObject request, HttpSession session) {
        super(method, tag, version, request, session);
    }

    /**
     * 一个最简单的远程函数示例，返回一个前面拼接了 Hello 的字符串
     * @param current
     * @param name
     * @return
     * @throws Exception
     */
    public Object sayHello(@NotNull JSONObject current, @NotNull String name) throws Exception{
        // 注意这里参数 name 是 key，不是 value
        Object obj = current.get(name);
        if (obj == null ){
            throw new IllegalArgumentException();
        }
        if (!(obj instanceof String)){
            throw  new IllegalArgumentException();
        }

        if (this.getSession() == null){
            return "Hello, inner test"; // 启动时的自动测试
        }
        // 之后可以用 this.getSession 拿到当前的 HttpSession

        return "Hello, " + obj.toString();
    }

    /**
     * 获取当前登录用户的 todo 条数和 title 长度之和
     * 在远程函数内，手动构造 APIJSON 请求读写数据库
     * 可以下断点看看构造的请求对应的 JSON 到底长什么样
     * @param current
     * @return
     * @throws Exception
     */
    public Object getNoteCountAPI(@NotNull JSONObject current) throws Exception{

        if (this.getSession() == null){
            return "Hello, inner test"; // 这是在启动时的自动测试
        }
        Long uid = (Long) this.getSession().getAttribute(APIJSONConstant.VISITOR_ID);
        if (uid == null) {
            throw new IllegalAccessException("user not logged in");
        }

        String TODO_CLASS_NAME = Todo.class.getSimpleName();

        // 构造一个 HEAD 请求来计数
        /*
        {
            "Todo": {
                "userId": 1627761019072,
                "@json": "helper"
            }
        }
        */

        JSONRequest todoItem = new JSONRequest(TODO_CLASS_NAME, new Todo().setUserId(uid));
        // 把 @json 放到 key Todo 里，不然反序列化的时候 helper 会被认为是字符串，从而造成反序列化异常
        todoItem.put(TODO_CLASS_NAME, todoItem.getJSONObject(TODO_CLASS_NAME).fluentPut(JSONRequest.KEY_JSON, "helper"));


        JSONResponse todoHeadResponse = new JSONResponse(new APIJSONParser(HEAD,false).parseResponse(todoItem));
        int todoCount = todoHeadResponse.getJSONResponse(StringUtil.firstCase(TODO_CLASS_NAME, false)).getCount();

        // 用 GET 得到所有 userId = uid 的 todo
        // 假设数据太多不能一次取完，使用分页（query=2，即每次取 2 个）
        // 参考请求 get todo by user id (unwrapped) + show page info
        /*
        {
            "Todo[]": {
                "Todo": {
                    "userId": 1,
                    "@json": "helper"
                },
                "count": 0,
                "page": 0,
                "query": 2
            },
            "total@": "/Todo[]/total",
            "info@": "/Todo[]/info"
        }
         */

        List<Todo> todos = new ArrayList<>();
        int page = 0;
        while (true) {
            // 构造分页请求
            JSONObject todoRequest = new JSONObject();
            todoItem.put(JSONRequest.KEY_QUERY, JSONRequest.QUERY_ALL);
            todoRequest.putAll(todoItem.toArray(2,page, TODO_CLASS_NAME)); // 模拟一个多页请求
            todoRequest.put("info@", "/Todo[]/info");

            // 按照 put key 的顺序输出 JSON，不加这个 MapSortField 的话就会出问题 info@ 可能在前面，造成引用赋值异常，拿不到页数信息
            JSONResponse todoResponse = new JSONResponse(new APIJSONParser(GET,false).parseResponse(JSONObject.toJSONString(todoRequest, SerializerFeature.MapSortField)));

            // 获取数据（解析为一个 List）
            todos.addAll(todoResponse.getObject(StringUtil.firstCase(TODO_CLASS_NAME,false) + "List", new TypeReference<List<Todo>>(){}));

            if (todoResponse.getJSONObject("info").getBooleanValue("more") == false){ // 没有更多了
                break;
            }
            page++;
        }

        int titleLengthSum = 0;
        for (Todo todo : todos) {
            titleLengthSum += todo.getTitle().length();
        }

        JSONObject returnObj = new JSONObject()
                .fluentPut("query_uid", uid)
                .fluentPut("todo_count_using_HEAD", todoCount)
                .fluentPut("title_length_sum", titleLengthSum);

        return returnObj;
    }

    /**
     * 获取 todo 表中的一行
     * 在远程函数中直接用最原始的 SQL 操作
     * @param current
     * @param id
     * @return
     * @throws Exception
     */
    public Object rawSQLAPI(@NotNull JSONObject current, @NotNull String id) throws Exception{
            Object obj = current.get(id);
            if (obj == null ){
                throw new IllegalArgumentException();
            }
            if (!(obj instanceof String)){
                throw  new IllegalArgumentException();
            }

            // 跳过框架初始化时的远程函数测试（理论上也可以加一个真实的 todoid，这里只是展示可以这样做）
            if ("_DOCUMENT_ONLY_".contentEquals(obj.toString())){
                return null;
            }

            long todoid = Long.parseLong((String)obj);

            SQLExecutor executor = new APIJSONParser().getSQLExecutor();
            DemoSQLConfig config = new DemoSQLConfig();

            String query = "SELECT * from " + config.getSQLSchema() + ".Todo where id = ?";

            Map<String, Object> resultMap = new HashMap<>();

            // ResultSet -> ResultMap
            try (PreparedStatement stmt = executor.getConnection(config).prepareStatement(query)) {
                stmt.setLong(1, todoid);
                ResultSet rs = stmt.executeQuery();
                ResultSetMetaData metaData = rs.getMetaData();
                while(rs.next()) {
                    for (int i=1; i<= metaData.getColumnCount(); i++){
                        resultMap.put(metaData.getColumnName(i), rs.getObject(i));
                    }
                }
            } catch (SQLException e){
                e.printStackTrace();
            }


            return resultMap;
    }

    /**
     * todo 的权限控制，在 POST/PUT 的时候被调用
     * 支持单独/批量的 PUT/POST
     * 默认策略：
     * 如果用户是 todo 的创建者，允许操作
     * 如果用户在 todo 的创建者的 friend 中，允许操作
     * 如果用户在 todo 的 helper 中，允许操作
     * 其他情况下禁止操作
     * @param current
     * @param todoId
     * @return
     * @throws Exception
     */
    public Object isUserCanPutTodo(@NotNull JSONObject current, @NotNull String todoId) throws Exception{
        Object idObj = current.get(todoId);
        Object idListObj = current.get(todoId + "{}"); // PUT tag=Todo[] 时用
        if (idObj == null && idListObj == null){
            throw new IllegalArgumentException();
        }
        if ((idObj instanceof Number && idListObj == null) ||            // 正常的单个请求
                (idListObj instanceof JSONArray) && idObj == null){      // PUT Todo[] 请求
            // continue
        } else {
            throw new IllegalArgumentException();
        }

        // 启动时的自动测试
        // 因为后面需要用户 Session，这里暂时随便返回一些东西让测试通过（不抛异常就行）
        if (this.getSession() == null){
            return null;
        }
        Long uid = (Long) this.getSession().getAttribute(APIJSONConstant.VISITOR_ID);
        if (uid == null) {
            throw new IllegalAccessException("user not logged in");
        }

        String TODO_CLASS_NAME = Todo.class.getSimpleName();

        List<Long> todoIdList = new ArrayList<>();

        if (idObj instanceof Number && idListObj == null){
            todoIdList.add(((Number) idObj).longValue());
        } else {
            JSONArray idListArray = (JSONArray) idListObj;
            for (int i = 0; i < idListArray.size(); i++) {
                todoIdList.add(idListArray.getLong(i));
            }
        }

        // 检查所有传入请求
        for (Long TodoId : todoIdList) {

            // 同时请求 User 和 Todo
            // 可以下断点看看构造的请求对应的 JSON 到底长什么样
            JSONObject todoRequest = new JSONRequest();
            todoRequest.put(TODO_CLASS_NAME, new apijson.JSONObject(new Todo().setId(TodoId)).setJson("helper"));
            JSONObject userRequest = new JSONRequest().fluentPut("id@", "/" + TODO_CLASS_NAME + "/userId")
                    .fluentPut("@json", "friends");
            todoRequest.put(DemoController.USER_CLASS_NAME, userRequest);

            JSONObject response = new APIJSONParser(GET, false).parseResponse(todoRequest);

            // 内部错误
            if (!JSONResponse.isSuccess(response)) {
                return APIJSONParser.extendErrorResult(response, new RuntimeException("inner error"));
            }
            // 如果不存在的话
            if (!response.containsKey(TODO_CLASS_NAME)) {
                return APIJSONParser.newErrorResult(new ConditionErrorException("to do not exist"));
            }

            JSONResponse todoResponse = new JSONResponse(response);
            Todo todo = todoResponse.getObject(Todo.class);
            User user = todoResponse.getObject(User.class);
            System.out.println(todo);

            // return null 是正常
            // throw excpetion 是异常
            // return 值是进行修改？


            if (todo.getUserId().equals(uid)) {
                // current user is creator
                continue;
            } else if (user.getFriends().contains(uid)) {
                // current user in creator's friend list
                continue;
            } else if (todo.getHelper() != null && todo.getHelper().contains(uid)) {
                // current user in todo's helper list
                continue;
            }

            // 以上验证都没有通过
            throw new IllegalAccessException("user don't have permission to put todo!");
        }

        // 所有的 todoid 都验证通过
        return null;
    }
}
