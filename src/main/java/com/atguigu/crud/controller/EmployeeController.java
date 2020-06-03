package com.atguigu.crud.controller;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;


import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



/**
 * 处理crud请求
 */
@Controller
public class EmployeeController {
    @Autowired
    EmployeeService employeeService;

    //删除 (单个/批量）
    @ResponseBody
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    public Msg deleteEmp(@PathVariable("ids") String ids){
        //批量删除
        if(ids.contains("-")){
            System.out.println("zou l ");
            List<Integer> del_ids = new ArrayList<Integer>();
            String[] str_ids = ids.split("-");
            //组装集合
            for (String empId : str_ids) {
                del_ids.add(Integer.parseInt(empId));
            }
            employeeService.daleteBacth(del_ids);
        }else {
            Integer empId = Integer.parseInt(ids);
            employeeService.daleteEmp(empId);
        }

        return Msg.success();
    }
    /*
    * 这里遇到个问题 假如直接发送AJAX=PUT请求的话 除了id全是null的问题
    * 请求体中是有要更新的数据的，但是我的employee对象并没有把他封装起来
    * 原因在于：
    * Tomcat：1.将请求体中的数据，封装成一个map
    *         2.从 request.getParameter("xxx")的map中取值
    *         3.SpringMvc封装POJO对象的时候 会把POJO每个属性的值以"2"中的方法去获得
    *          然而 对于AJAX发送的PUT请求 Tomcat是不会去封装其中的请求体中的数据的 只有POST才会封装
    *           Request有一个方法叫：parseParameters()方法 中有一个 ！getConnector（）.isParseMethodBody
    *           但是默认的parsebodymethod返回值是post 才能进行后续的部分 因此不行
    *           假如想用put 还想封装请求体中的数据 就必须用filter-->将请求体中的数据包装成了一个map（完成tomcat任务）
    *           request被重新包装后，里面就有数据了，就能从里面的map取出来对应的数据了
    *
    * */
    //员工更新 用put请求就是更新
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    public Msg saveEmp(Employee employee){
        employeeService.updateEmp(employee);
        return  Msg.success();
    }
    //根据ID查询 用get请求就是查询
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id")Integer id){
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp",employee);
    }
    //检查用户名是否可用

    @ResponseBody
    @RequestMapping("/checkuser")
    public Msg checkuser(@RequestParam("empName") String empName){
        //先看用户名是不是合法的表达式
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if(!empName.matches(regx)){
            return Msg.fail().add("va_msg","用户名必须是2-5位中文或者6-16位英文数字组合");
        }
        System.out.println("zou 了吗");
        //数据库用户名重复校验 以状态码的识别作为检验的标准
        boolean b = employeeService.checkUser(empName);
        if(b){
            return Msg.success();
        }else {
            return Msg.fail().add("va_msg","该用户名已被使用");
        }

    }
    //保存员工信息 这里用的post方法
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if(result.hasErrors()){
            //校验失败，应该返回失败，在模态框中显示校验失败的错误信息
            Map<String, Object> map = new HashMap<String, Object>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError fieldError : errors) {
                System.out.println("错误的字段名："+fieldError.getField());
                System.out.println("错误信息："+fieldError.getDefaultMessage());
                map.put(fieldError.getField(), fieldError.getDefaultMessage());
            }
            return Msg.fail().add("va_msg","该用户名不可用");
        }else{
            employeeService.saveEmp(employee);
            return Msg.success();
        }

    }

    public String getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Model model){
        //引入分页插件
        //在查询之前只需要调用  传入页码 以及分页大小
        PageHelper.startPage(pn,5);//每次查几页，一页中显示几条数据
        //startPage后面紧跟的查询就是一个分页查询
        List<Employee> emps = employeeService.getAll();
        //如果想要用pageInfo包装查询后的结果，只需要将Pageinfo交给页面就行
        PageInfo page = new PageInfo(emps,5);//连续显示的页数（12345...23456...）
        model.addAttribute("pageInfo",page);
        return "list";
    }

    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1") Integer pn){
        //引入分页插件
        //在查询之前只需要调用  传入页码 以及分页大小
        PageHelper.startPage(pn,5);
        //startPage后面紧跟的查询就是一个分页查询
        List<Employee> emps = employeeService.getAll();
        PageInfo page = new PageInfo(emps,5);//连续显示的页数（12345...23456...）
        //有了json的插件 就可以直接的返回了
        return Msg.success().add("pageInfo",page);//携带数据
    }


}
