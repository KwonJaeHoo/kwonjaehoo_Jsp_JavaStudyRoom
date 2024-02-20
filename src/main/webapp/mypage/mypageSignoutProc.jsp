<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.web.dao.UserDao" %>

<%
	Logger logger = LogManager.getLogger("/mypage/mypageSignoutProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieId = CookieUtil.getValue(request, "UD_ID");
	
	String message = "";
	String redirectUrl = "/mypage/mypageSignout.jsp";
	boolean mypageDeleteSuccess = false;
	
	String udId = HttpUtil.get(request, "udId");
	String udPwd = HttpUtil.get(request, "udPwd");
	
	if(!StringUtil.isEmpty(udId) && !StringUtil.isEmpty(udPwd))
	{
		UserDao userDao = new UserDao();
		User user = userDao.userSelect(udId);
		
		if(user != null)
		{
			if(StringUtil.equals(cookieId, user.getUdId()) && StringUtil.equals(udPwd, user.getUdPwd()))
			{
				user.setUdStatus("S");
			
				if(userDao.userStatusUpdate(user) > 0)
				{
					message = "회원탈퇴가 완료되었습니다.";
					mypageDeleteSuccess = true;
				}
				else
				{
					message = "회원탈퇴 진행 중 오류가 발생 하였습니다.";
				}
			}
			else
			{
				message = "탈퇴 할 아이디와 현재 로그인한 아이디 값이 다르거나 비밀번호 값이 일치하지 않습니다.";
			}
		}
		else
		{
			message = "존재하지 않는 사용자입니다.";
		}
	}
	else
	{
		message = "입력 값이 잘못 되었습니다.";
	}

	if(mypageDeleteSuccess)
	{
		redirectUrl = "/";
	}
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>

<script>
$(document).ready(function()
{
<%
	if(mypageDeleteSuccess)
	{
%>
		alert("<%=message%>");	
		location.href = "<%=redirectUrl%>";
		
<%
		CookieUtil.deleteCookie(request, response, "/", "UD_ID");
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
</head>
<body>
<body>
<%@ include file="/include/navigation.jsp" %>

</body>
</html>