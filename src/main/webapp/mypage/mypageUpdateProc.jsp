<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.web.dao.UserDao" %>

<%
	Logger logger = LogManager.getLogger("/mypage/mypageUpdateProc.jsp");
	HttpUtil.requestLogString(request, logger);

	String cookieId = CookieUtil.getValue(request, "UD_ID");
	
	String message = "";
	String redirectUrl = "/mypage/mypageUpdate.jsp";
	boolean updateSuccess = false;
	
	String udId = HttpUtil.get(request, "udId");
	String udPwd = HttpUtil.get(request, "udPwd");
	String udNickname = HttpUtil.get(request, "udNickname");
	String udEmail = HttpUtil.get(request, "udEmail");
	String udPhone = HttpUtil.get(request, "udPhone");
	
	if(!StringUtil.isEmpty(udId) && !StringUtil.isEmpty(udPwd) && !StringUtil.isEmpty(udNickname) && !StringUtil.isEmpty(udEmail) && !StringUtil.isEmpty(udPhone))
	{
		UserDao userDao = new UserDao();
		User user = userDao.userSelect(udId);
		
		if(user != null)
		{
			if(StringUtil.equals(cookieId, user.getUdId()))
			{		
				if(	(StringUtil.equals(udNickname, user.getUdNickname()) || StringUtil.equals(udEmail, user.getUdEmail()) || StringUtil.equals(udPhone, user.getUdPhone()))
						|| 
					(!(userDao.udNicknameCount(udNickname) > 0) && !(userDao.udEmailCount(udEmail) > 0) && !(userDao.udPhoneCount(udPhone) > 0)) )
				{
	
					user.setUdPwd(udPwd);
					user.setUdNickname(udNickname);
					user.setUdEmail(udEmail);
					user.setUdPhone(udPhone);
					
					if(userDao.userUpdate(user) > 0)
					{
						message = "회원정보가 변경되었습니다.";
						updateSuccess = true;
					}
					else
					{
						message = "사용자 정보 변경 중 오류가 발생 하였습니다.";
					}
				}
				else
				{
					message = "입력 된 정보 중 중복되는 값이 있습니다.";
				}
			}
			else
			{
				message = "정보 변경 할 아이디와 현재 로그인한 아이디 값이 다릅니다.";
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
	
	if(updateSuccess)
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
	if(updateSuccess)
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