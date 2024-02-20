<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%
	Logger logger = LogManager.getLogger("/index2.jsp");
	HttpUtil.requestLogString(request, logger);

	String cookieId = CookieUtil.getValue(request, "UD_ID");
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<script>
$(document).ready(function()
{
	$("#mypageBtn").on("click", function()
	{
		location.href = "/mypage/mypage.jsp";
	});
			
	$("#listBtn").on("click", function()
	{
		location.href = "/board/list.jsp";
	});
});
</script>
</head>
<body>
<%
	if(StringUtil.isEmpty(cookieId))
	{	
%>
<script>
		alert("잘못된 접근입니다.");
		location.href = "/";
</script>		
<%
	}
	else
	{
%>
<%@ include file="/include/navigation.jsp" %>


<div class="container">
	<h3>메인</h3>
	<button type="button" id="mypageBtn" class="btn btn-lg btn-primary btn-block">마이페이지</button>
    <button type="button" id="listBtn" class="btn btn-lg btn-primary btn-block" type="submit">게시판</button>
</div>
</body>
</html>
<% 
	}
%>