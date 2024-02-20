<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%
	Logger logger = LogManager.getLogger("/mypage/mypage.jsp");
	HttpUtil.requestLogString(request, logger);

%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>

<script>
$(document).ready(function()
{
	$("#mypageUpdateBtn").on("click", function()
	{
		location.href = "/mypage/mypageUpdate.jsp";
	});
			
	$("#mypageWriteBtn").on("click", function()
	{
		location.href = "/mypage/mypageWrite.jsp";
	});
	
	$("#mypageSignoutBtn").on("click", function()
	{
		location.href = "/mypage/mypageSignout.jsp";
	});
});
</script>

</head>
<body>
<body>
<%@ include file="/include/navigation.jsp" %>


<div class="container">
	<h3> 마이페이지 </h3>
	<button type="button" id="mypageUpdateBtn" class="btn btn-lg btn-primary btn-block">내 정보 수정</button>
	<button type="button" id="mypageWriteBtn" class="btn btn-lg btn-primary btn-block">내가 쓴 글</button>
	<button type="button" id="mypageSignoutBtn" class="btn btn-lg btn-primary btn-block">회원 탈퇴</button>
</div>

</body>
</html>