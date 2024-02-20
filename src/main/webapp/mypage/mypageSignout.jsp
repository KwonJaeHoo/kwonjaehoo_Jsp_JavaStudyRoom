<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.web.dao.UserDao" %>

<%
	Logger logger = LogManager.getLogger("/mypage/mypageSignout.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieId = CookieUtil.getValue(request, "UD_ID");

	UserDao userDao = new UserDao();
	User user = userDao.userSelect(cookieId);
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>

<script>
$(document).ready(function()
{
	$("#udPwd1").focus();
	
	$("#mypageDeleteBtn").on("click", function()
	{
		if($("#udPwd").val() != $("#udPwd1").val())
		{
			alert("비밀번호가 일치하지 않습니다.");
			$("#udPwd1").val("");
			$("#udPwd1").focus();
			return;
		}
		if(confirm("정말로 회원탈퇴를 진행 하시겠습니까?") == true)
		{
			document.mypageSignoutForm.submit();
		}
	});
});
</script>
</head>
<body>
<body>
<%@ include file="/include/navigation.jsp" %>

<div class="container">
    <div class="row mt-5">
		<h3>회원탈퇴</h3>
    </div>
    <div class="row mt-5">
		<h6> 정말로 회원탈퇴를 진행 하시겠어요? 동의하시면 비밀번호를 입력해주세요.</h6>
    </div>
    <form name="mypageSignoutForm" id="mypageSignoutForm" action="/mypage/mypageSignoutProc.jsp" method="post">
	    <div class="form-group">
	    	<input type="hidden" id="udId"  name="udId" value="<%=user.getUdId()%>">
			<input type="hidden" id="udPwd"  name="udPwd" value="<%=user.getUdPwd()%>">
	    	<label for="username">비밀번호</label> <small id="HelpInline" class="text-muted">  </small>
	    	<input type="password" class="form-control" id="udPwd1" name="udPwd1" value="" placeholder="비밀번호" maxlength="32">
	   </div>
	</form>
	<button type="button" id="mypageDeleteBtn" class="btn btn-primary">회원탈퇴</button>
</div>

</body>
</html>