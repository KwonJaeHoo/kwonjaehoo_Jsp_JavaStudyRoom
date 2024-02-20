<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.web.dao.UserDao" %>

<%
	Logger logger = LogManager.getLogger("/user/signupProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieId = CookieUtil.getValue(request, "UD_ID");
	
	String message = "";
	String redirectUrl = "/user/signup.jsp";
	boolean signupSuccess = false;
	
	String udId = HttpUtil.get(request, "udId");
	String udPwd = HttpUtil.get(request, "udPwd");
	String udName = HttpUtil.get(request, "udName");
	String udNickname = HttpUtil.get(request, "udNickname");
	String udEmail = HttpUtil.get(request, "udEmail");
	String udPhone = HttpUtil.get(request, "udPhone");

	if(!StringUtil.isEmpty(cookieId))
	{
		//로그인 되어있으면 안됨
		message = "잘못된 접근입니다.";
		redirectUrl = "/index2.jsp";
	}
	else
	{
		if(!StringUtil.isEmpty(udId) && !StringUtil.isEmpty(udPwd) && !StringUtil.isEmpty(udName) && !StringUtil.isEmpty(udNickname) && !StringUtil.isEmpty(udEmail) && !StringUtil.isEmpty(udPhone))
		{
			UserDao userDao = new UserDao();
			User user = null;
			
			if(!(userDao.udIdCount(udId) > 0) && !(userDao.udNicknameCount(udNickname) > 0) && !(userDao.udEmailCount(udEmail) > 0) && !(userDao.udPhoneCount(udPhone) > 0))
			{
				user = new User();
				user.setUdId(udId);
				user.setUdPwd(udPwd);
				user.setUdName(udName);
				user.setUdNickname(udNickname);
				user.setUdEmail(udEmail);
				user.setUdPhone(udPhone);
				user.setUdStatus("Y");
				user.setUdAuth("U");
				
				if(userDao.userInsert(user) > 0)
				{	
					message = "회원가입이 완료 되었습니다.";
					signupSuccess = true;
				}
				else
				{
					message = "사용자 정보 등록 중 오류가 발생 하였습니다.";
				}
			}
			else
			{
				//값이 중복되는 경우
				message = "입력 된 정보 중 중복되는 값이 있습니다.";
			}
		}
		else
		{
			//값이 하나라도 비어있으면 false
			message = "입력 값이 잘못 되었습니다.";
		}
	}
	
	if(signupSuccess)
	{
		redirectUrl = "/";
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
	alert("<%=message%>");
	location.href = "<%=redirectUrl%>";
});
</script>
<body>

</body>
</html>