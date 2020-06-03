<%--
  Created by IntelliJ IDEA.
  User: lenovo
  Date: 2020/5/29
  Time: 22:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<jsp:forward page="/emps"></jsp:forward>--%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>员工列表</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>
    <link rel="stylesheet" href="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
<%--update modal修改员工信息的模态框--%>
<div class="modal fade" tabindex="-1" role="dialog" id="empUpdateModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">修改员工</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                            <span  class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@qq.com">
                            <span  class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>

                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <%--   提交部门ID--%>
                            <select class="form-control" name="dId">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->

</div><!-- /.modal -->
<%--add model 添加员工的模态框--%>
<div class="modal fade" tabindex="-1" role="dialog" id="empAddModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <!--员工名字的添加框-->
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                            <span  class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <!--员工邮箱的添加框-->
                            <input type="text" name="email" class="form-control" id="email_input" placeholder="email@qq.com">
                            <span  class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <!--员工性别的添加框 内联单选-->
                                <input type="radio" name="gender" id="gender1_input" value="M" checked> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_input" value="F"> 女
                            </label>

                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <%--  部门提交部门ID就好了 --%>
                            <select class="form-control" name="dId">
<%--                                <option value="'1">开发部</option>--%>
<%--                                <option value="2">测试部</option>--%>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->

</div><!-- /.modal -->
<%--  搭建显示页面--%>
<div class="container">
    <%--        标题--%>
    <div class="row">
        <div class="col-md-12">
            <h1>EMBEDDED团队-CRUD系统</h1>
        </div>
    </div>
    <%--    按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
        </div>
    </div>
    <%--    表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="checkBox_all" autocomplete="off"/>
                    </th>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <%--    显示分页信息--%>
    <div class="row">
        <div class="col-md-6" id="page_info_area">

        </div>
        <%--            分页条--%>
        <div class="col-md-6" id="page_nav">


        </div>
    </div>
</div>
<script type="text/javascript">
    //定义一个总页数 和一个当前页数
    var totalRecord,currentPage;
    //1.页面加载完以后  直接发送一个请求  要到分页数据
    $(function () {
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn=1",
            type:"GET",
            success:function (result) {
                //console.log(result);
                //1.拿到数据以后要解析并且显示员工数据
                build_emps_table(result);
                //2.解析并显示分页信息
                build_page_info(result);
                //3.解析显示分页条信息
                build_page_nav(result);
            }
        });
    });

    //1.页面加载完成以后  直接去发送ajax请求，要到分页数据
    $(function () {
        //去首页
        to_page(1);
    })
    function to_page(pn) {
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn=" + pn,
            type:"GET",
            success:function (result) {
                //console.log(result);
                //1.拿到数据以后要解析并且显示员工数据
                build_emps_table(result);
                //2.解析并显示分页信息
                build_page_info(result);
                //3.解析显示分页条信息
                build_page_nav(result);
            }
        });
    }
    //解析显示表格信息
    function build_emps_table(result){
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps,function (index,item) {
            var checkBoxTD = $("<td><input type='checkbox' class='check_item'/></td>");
            var empIdTD = $("<td></td>").append(item.empId);
            var empNameTD = $("<td></td>").append(item.empName);
            var genderTD = $("<td></td>").append(item.gender=='M'?"男":"女");
            var emailTD = $("<td></td>").append(item.email);
            var deptNameTD = $("<td></td>").append(item.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑")
            ;
            //为编辑按钮增加一个自定义属性  来表示当前员工的id
            editBtn.attr("edit-id",item.empId);
            var daleBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除")
            ;
            //为删除按钮增加一个自定义属性  来表示当前员工的id
            daleBtn.attr("delete-id",item.empId);
            var btnTD = $("<td></td>").append(editBtn).append(" ").append(daleBtn);
            $("<tr></tr>")
                .append(checkBoxTD)
                .append(empIdTD)
                .append(empNameTD)
                .append(genderTD)
                .append(emailTD)
                .append(deptNameTD)
                .append(btnTD)
                .appendTo("#emps_table tbody");
        });
    }
    //解析显示分页信息
    function build_page_info(result) {
        $("#page_info_area").empty();
        $("#page_info_area").append("当前"+result.extend.pageInfo.pageNum +
            "页,总"+result.extend.pageInfo.pages +"页，总"+result.extend.pageInfo.total +"条记录");
        totalRecord = result.extend.pageInfo.total;
        currentPage = result.extend.pageInfo.pageNum;
    }
    //解析显示分页条  点击分页能跳转
    function build_page_nav(result) {
        $("#page_nav").empty();
        var ul = $("<ul></ul>").addClass("pagination");
        var firstLi = $("<li></li>").append($("<a></a>").
        append("首页").attr("href","#"))

        var prePageLi = $("<li></li>").append($("<a></a>").
        append("&laquo;"));
        if(result.extend.pageInfo.hasPreviousPage == false){
            firstLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else {
            //为元素添加点击翻页的事件
            firstLi.click(function () {
                to_page(1);
            });
            prePageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum - 1);
            });
        }

        var nextPageLi = $("<li></li>").append($("<a></a>").
        append("&raquo;"));

        var lastLi = $("<li></li>").append($("<a></a>").
        append("末页").attr("href","#"))

        if(result.extend.pageInfo.hasNextPage == false){
            nextPageLi.addClass("disabled");
            lastLi.addClass("disabled");
        }else {
            nextPageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum + 1);
            });
            lastLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            });
        }
        //添加首页和上一页
        ul.append(firstLi).append(prePageLi);

        $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {

            var numLi = $("<li></li>").append($("<a></a>").append(item));
            //注意顺序
            if(result.extend.pageInfo.pageNum == item){
                numLi.addClass("active")
            }
            numLi.click(function () {
                to_page(item);
            })
            ul.append(numLi);
        });
        //添加下一页和末页
        ul.append(nextPageLi).append(lastLi);

        //把ul加入nav
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav");
    }
    
    //清空表单样式和内容
    function reset_form(ele){
        $(ele)[0].reset();//清空内容
        $(ele).find("*").removeClass("has-error has-success");//表单下面的所有都去掉  *
        $(ele).find(".help-block").text("");//信息提示框 也重置

    }
    //点击新增按钮弹出模态框
    $("#emp_add_modal_btn").click(function () {
        //清除表单数据（表单重置）
        //$("#empAddModal form")[0].reset();  抽取出一个方法
        reset_form("#empAddModal form");
        //发送AJAX请求 查询出信息显示在下拉列表
        getDepts("#empAddModal select");
        //弹出模态框
        $("#empAddModal").modal({
            backdrop:"static"
        });
    });

    //发送ajax请求 查询出所有部门信息并显示在下拉列表中
    function getDepts(ele) {
        $(ele).empty();
        $.ajax({
            url:"${APP_PATH}/depts",
            type:"GET",
            success:function (result) {
                console.log(result)
                //$("#empAddModal select").append("<option></option>")
                $.each(result.extend.depts,function () {
                    var optionEl = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                    optionEl.appendTo(ele);
                });
            }
        });
    }
   //校验表单数据分成2部分：校验名字邮箱---校验用户名是否可用----
    //校验名字邮箱
    function validate_add_form(){
        //使用正则表达式进行校验
        var empName = $("#empName_add_input").val();
        var regNmae = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        if(!regNmae.test(empName)){
            //alert("用户名2-5中文或者6-16位英文数字组合");
            // $("#empName_input").parent().addClass("has-error");
            // $("#empName_input").next("span").text("用户名2-5中文或者6-16位英文数字组合");
            show_validate_msg("#empName_add_input","error","用户名2-5中文或者6-16位英文数字组合");//用的css的
            return false;
        }else {

            show_validate_msg("#empName_add_input","success","");
        };
        var email = $("#email_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if(!regEmail.test(email)){
            //alert("邮箱格式不正确");
            //应该清空元素之前的样式
            // $("#email_input").parent().addClass("has-error");
            // $("#email_input").next("span").text("邮箱格式不正确");
            show_validate_msg("#email_input","error","邮箱格式不正确")//css的
            return false;
        }else {
            // $("#email_input").parent().addClass("has-success");
            // $("#email_input").next("span").text("邮箱有效");
            show_validate_msg("#email_input","success","")//css的
        };
        return true;
    }

    //显示校验结果的提示信息
    function show_validate_msg(ele,status,msg){
        //首先清除状态 不然的话会在失败/成功的基础上再添加一层新的状态信息
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        //假如成功
        if ("success"==status){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
            //假如失败
        }else if ("error"==status){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }

    //检验用户名是否可用
    $("#empName_add_input").change(function(){
        var empName = this.value;
        $.ajax({
            url:"${APP_PATH}/checkuser",
            data:"empName="+empName,
            type:"POST",
            success:function (result) {
                if(result.code==100){
                    show_validate_msg("#empName_add_input","success","用户名可用");
                    $("#emp_save_btn").attr("ajax_va","success");
                }else {
                    show_validate_msg("#empName_add_input","error",result.extend.va_msg);
                    $("#emp_save_btn").attr("ajax_va","error");
                }
            }
        });
    });


    //点击保存员工
    $("#emp_save_btn").click(function () {
        //1.模态框中填写的表单数据提交给服务器进行保存
        //2.对要提交给服务器的数据进行校验
        if (!validate_add_form()){
            return false;
        };
        //在这要判断之前的用户名校验是否成功  如果成功了  才能够正常往下进行
        if($(this).attr("ajax_va")=="error"){
            return false;
        }
        //3.发送ajax请求
        $.ajax({
            url:"${APP_PATH}/emp",
            type:"POST",
            //序列化表格数据
            //下面这一行代码的结果就是得到要提交的表单的数据
            data:$("#empAddModal form").serialize(),
            success:function (result) {
                // alert(result.msg)
                //这里要判断后台
                if(result.code == 100){
                    //1.处理成功对话框关闭（关闭模态框）
                    $("#empAddModal").modal('hide');
                    //2.跳到最后一页显示保存的员工
                    to_page(totalRecord);
                }else {
                    //显示失败信息
                    //console.log(result)
                    //有哪个字段错误就会显示哪个字段错误
                    //邮箱错误
                    if(undefined != result.extend.errorFields.email){
                        show_validate_msg("#email_input","error",result.extend.errorFields.email);
                    }
                    //用户名错误
                    if(undefined != result.extend.errorFields.empName){
                        show_validate_msg("#empName_add_input","error",result.extend.errorFields.empName)
                    }
                }

            }
        });

    });
    //单个删除
    $(document).on("click",".delete_btn",function () {
        //1 弹出确认删除对话框
        //alert($(this).parents("tr").find("td:eq(1)").text());
        var empName = $(this).parents("tr").find("td:eq(2)").text();
        var empId = $(this).attr("delete-id");
        if (confirm("确认删除【"+empName+ "】吗？")){
            //确认发送ajax请求
            $.ajax({
                url:"${APP_PATH}/emp/" + empId,
                type:"DELETE",
                success:function (result) {
                    alert(result.msg);
                    //回到本页
                    to_page(currentPage);
                }
            });
        }
    });
    //绑定单击事件   编辑以下是绑定不上的 因为我们是按钮创建之前就绑定了click 所以绑定不上的
    //有两种方法解决：一是在创建的时候就绑定 那么就得回到上面 再加一点功能
    //第二种方法就是：绑定事件用live方法 但是新版Jquery没有live  用了on方法代替
    //     $(".edit_btn").click(function () {
    //             alert("edit")
    //     })
    $(document).on("click",".edit_btn",function () {
        //alert("edit")
        // 1显示部门信息  并显示部门列表
        getDepts("#empUpdateModal select");
        //2查出员工信息  显示员工信息
        getEmp($(this).attr("edit-id"));
        //3 把员工ID传递给模态框的更新按钮
        $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
        //弹出编辑模态框
        $("#empUpdateModal").modal({
            backdrop:"static"
        });

    });
    //1 查出员工信息  显示员工信息
    function getEmp(id) {
        $.ajax({
            url:"${APP_PATH}/emp/"+id,
            type:"GET",
            success:function (result) {
                //console.log(result);
                var empData = result.extend.emp;
                $("#empName_update_static").text(empData.empName);
                $("#email_update_input").val(empData.email);
                $("#empUpdateModal input[name=gender]").val([empData.gender]);
                $("#empUpdateModal select").val([empData.dId]);
            }

        });
    }
    //点击更新  更新员工信息
    $("#emp_update_btn").click(function () {
        //验证邮箱是否合法
        var email = $("#email_update_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if(!regEmail.test(email)){
            show_validate_msg("#email_update_input","error","邮箱格式不正确")
            return false;
        }else {
            show_validate_msg("#email_update_input","success","")
        }
        //发送ajax请求  保存更新的员工数据
        $.ajax({
            url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
            //更新要用PUT 如果用POST 就在serialize后加上一句：+&_method=PUT
            type:"PUT",
            //调用员工修改模态框的表单里的序列化后的结果 （序列化：表格内容->字符串）
            data:$("#empUpdateModal form").serialize(),
            success:function (result) {
                //alert(result.msg);  1 关闭模态框
                $("#empUpdateModal").modal('hide');
                //2 回到本页面
                to_page(currentPage);
            }
        });
    });
    //完成全选  全不选
    $("#checkBox_all").click(function () {

        //$(this).prop("checked")
        $(".check_item").prop("checked",$(this).prop("checked"));
    });
    //check_item
    $(document).on("click",".check_item",function () {
        //判断当前选中的元素是不是五个  选中的个数是不是等于复选框的个数
        var flag =  $(".check_item:checked").length==$(".check_item").length;
        $("#checkBox_all").prop("checked",flag);
    });
    //点击全部删除
    $("#emp_delete_all_btn").click(function () {
        //遍历找到每一个被选中的name
        var empNames = "";
        var del_idstr = "";
        $.each($(".check_item:checked"),function () {
            $(this).parents("tr").find("td:eq(2)").text();
            empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
            //组装员工ID字符串
            del_idstr += $(this).parents("tr").find("td:eq(1)").text()+"-";
        });
        empNames = empNames.substring(0,empNames.length - 1);
        del_idstr = del_idstr.substring(0,del_idstr.length - 1);
        if(confirm("确认删除【"+ empNames +"】吗？")){
            //发送ajax请求
            $.ajax({
                url:"${APP_PATH}/emp/" + del_idstr,
                type:"DELETE",
                success:function (result) {
                    alert(result.msg);

                    to_page(currentPage);
                }
            })

        }
    })
</script>
</body>
</html>
