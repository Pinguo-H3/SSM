package com.atguigu.crud.bean;

//通用返回类

import java.util.HashMap;
import java.util.Map;

public class Msg {
    //状态码 100-成功 200-失败
    private int code;

    //提示信息
    private String msg;


    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }

    ////用户要返回给浏览器的数据 用一个Hashmap来存储
    private Map<String,Object> extend = new HashMap<String, Object>();

    //如果请求成功的话 方法：
    public static Msg success(){
        Msg result = new Msg();
        result.setCode(100);
        result.setMsg("处理成功");
        return result;
    }
    //请求失败的话 方法：
    public static Msg fail(){
        Msg result = new Msg();
        result.setCode(200);
        result.setMsg("处理失败");
        return result;
    }

    public Msg add(String key,Object value){
        this.getExtend().put(key,value);
        return this;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
