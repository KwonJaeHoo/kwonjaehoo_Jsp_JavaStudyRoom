<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.web.dao.UserDao" %>

<%
	Logger logger = LogManager.getLogger("/user/loginProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieId = CookieUtil.getValue(request, "UD_ID");
	
	String message = "";
	String redirectUrl = "/";
	boolean loginSuccess = false;

	String udId = HttpUtil.get(request, "udId");
	String udPwd = HttpUtil.get(request, "udPwd");

	if(!StringUtil.isEmpty(cookieId))
	{
		message = "잘못된 접근입니다.";
		redirectUrl = "/index2.jsp";
	}
	else
	{
		if(!StringUtil.isEmpty(udId) && !StringUtil.isEmpty(udPwd))
		{
			UserDao userDao = new UserDao();
			User user = userDao.userSelect(udId);
			
			if(user != null)
			{
				//입력받은 id값에 해당되는 pwd 와 입력된 pwd가 같은가?
				if(StringUtil.equals(udPwd, user.getUdPwd()))
				{
					//정지된 사용자인가요?
					if(StringUtil.equals("Y", user.getUdStatus()))
					{
						loginSuccess = true;
					}
					else if(StringUtil.equals("N", user.getUdStatus()))
					{
						message = "정지된 사용자 입니다.";
					}
					//Status 'S'
					else
					{
						message = "탈퇴한 사용자 입니다.";
					}
				}
				else
				{
					message = "아이디 또는 비밀번호를 잘못 입력했습니다.";
				}
			}
			else
			{
				message = "아이디 또는 비밀번호를 잘못 입력했습니다.";
			}	
		}
		else
		{
			message = "아이디 또는 비밀번호를 잘못 입력했습니다.";
		}
	}
	
	if(loginSuccess)
	{
		redirectUrl = "/index2.jsp";
	}
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
</head>
<script>
$(document).ready(function() 
{
<%
	if(loginSuccess)
	{
%>
		location.href = "<%=redirectUrl%>";
<%
		CookieUtil.addCookie(response, "/", "UD_ID", udId);
	}
	else
	{
%>
		alert("<%=message%>");
		location.href = "<%=redirectUrl%>";
<%
	}
%>		
});
</script>
<body>

</body>
</html>