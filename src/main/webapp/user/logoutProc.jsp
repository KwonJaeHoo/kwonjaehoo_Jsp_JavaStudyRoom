<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.web.dao.UserDao" %>

<%
	Logger logger = LogManager.getLogger("/user/logoutProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	if(CookieUtil.getValue(request, "UD_ID") != null)
	{
		// "/" 까먹지말것, 쿠키 add경로를 "/"로 지정했기 때문에 삭제할때도 경로 삭제해주는것
		CookieUtil.deleteCookie(request, response, "/", "UD_ID");	
	}
	//index.jsp로 다시 보내버림
	response.sendRedirect("/");	
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<script>
	
</script>
</head>
<body>

</body>
</html>