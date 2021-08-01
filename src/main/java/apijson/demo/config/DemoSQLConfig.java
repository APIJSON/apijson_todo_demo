package apijson.demo.config;

import apijson.RequestMethod;
import apijson.framework.APIJSONSQLConfig;
import apijson.orm.SQLConfig;

import java.util.Arrays;

public class DemoSQLConfig extends APIJSONSQLConfig {

    public DemoSQLConfig() {super();}
    public DemoSQLConfig(RequestMethod method, String table) {super(method, table);}

    static {
        DEFAULT_DATABASE = "MYSQL";  // MYSQL, POSTGRESQL, SQLSERVER, ORACLE, DB2
        DEFAULT_SCHEMA = "apijson_todo_demo";  // 数据库的 Schema 名
    }

    @Override
    public String getDBVersion() {
        return "8.0";
    }

    @Override
    public String getDBUri() {
        return "jdbc:mysql://192.168.99.100:33308?serverTimezone=GMT%2B8&useUnicode=true&characterEncoding=UTF-8";
    }

    @Override
    public String getDBAccount() {
        return "root";
    }

    @Override
    public String getDBPassword() {
        return "apijson";
    }
}
