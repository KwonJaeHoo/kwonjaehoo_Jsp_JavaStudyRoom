<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.web.dao.UserDao" %>

<%
	Logger logger = LogManager.getLogger("/index.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieId = CookieUtil.getValue(request, "UD_ID");
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<style>
	body 
	{
	  /* padding-top: 40px; */
	  padding-bottom: 40px;
	  /* background-color: #eee; */
	}
	.form-signin 
	{
	  max-width: 330px;
	  padding: 15px;
	  margin: 0 auto;
	}
	.form-signin .form-signin-heading,
	.form-signin .checkbox 
	{
	  margin-bottom: 10px;
	}
	.form-signin .checkbox 
	{
	  font-weight: 400;
	}
	.form-signin .form-control 
	{
	  position: relative;
	  -webkit-box-sizing: border-box;
	  -moz-box-sizing: border-box;
	  box-sizing: border-box;
	  height: auto;
	  padding: 10px;
	  font-size: 16px;
	}
	.form-signin .form-control:focus
	{
	  z-index: 2;
	}
	.form-signin input[type="text"] 
	{
	  margin-bottom: 5px;
	  border-bottom-right-radius: 0;
	  border-bottom-left-radius: 0;
	}
	.form-signin input[type="password"] 
	{
	  margin-bottom: 10px;
	  border-top-left-radius: 0;
	  border-top-right-radius: 0;
	}
	
</style>
<script>
$(document).ready(function()
{
	$("#loginBtn").on("click", function()
	{
		if($.trim($("#udId").val()).length <= 0)
		{
			alert("아이디를 입력해주세요.");	
			$("#udId").val("");
			$("#udId").focus();
			return;
		}
		if($.trim($("#udPwd").val()).length <= 0)
		{
			alert("비밀번호를 입력해주세요.");	
			$("#udPwd").val("");
			$("#udPwd").focus();
			return;
		}
		
		document.loginForm.submit();
	});
	
	$("#signupBtn").on("click", function()
	{
		location.href = "/user/signup.jsp";
	});
});
</script>
</head>
<body>
<%
	if(!StringUtil.isEmpty(cookieId))
	{	
%>
<script>
		alert("잘못된 접근입니다.");
		location.href = "/index2.jsp";
</script>		
<%
	}
	else
	{
%>

<%@ include file="/include/navigation.jsp" %>

<div class="container">

	<form name="loginForm" id="loginForm" method="post" action="/user/loginProc.jsp" class="form-signin">
	    <h2 class="form-signin-heading m-b3">로그인</h2>
		<label for="userId" class="sr-only">아이디</label>
		<input type="text" id="udId" name="udId" class="form-control" maxlength="16" placeholder="아이디">
		<label for="userPwd" class="sr-only">비밀번호</label>
		<input type="password" id="udPwd" name="udPwd" class="form-control" maxlength="32" placeholder="비밀번호">
		  
		<button type="button" id="loginBtn" class="btn btn-lg btn-primary btn-block">로그인</button>
    	<button type="button" id="signupBtn" class="btn btn-lg btn-primary btn-block" type="submit">회원가입</button>
	</form>
</div>
</body>
</html>
<% 
	}
%>
