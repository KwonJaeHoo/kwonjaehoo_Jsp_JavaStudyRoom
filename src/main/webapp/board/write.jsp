<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.web.dao.UserDao" %>

<%
	Logger logger = LogManager.getLogger("/board/write.jsp");
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
	$("#writeBtn").on("click", function()
	{	
		if($("#bdSecret").is(":checked"))
		{
			$("#bdSecret").val("Y");
		}
		else
		{
			$("#bdSecret").val("N");	
		}
		
		if($.trim($("#bdTitle").val()).length <= 0)
		{
			alert("제목을 입력해주세요.");
			$("#bdTitle").val("");
			$("#bdTitle").focus();
			return;
		}
		
		if($.trim($("#bdContent").val()).length <= 0)
		{
			alert("내용을 입력해주세요.");
			$("#bdContent").val("");
			$("#bdContent").focus();
			return;
		}
		
		if(confirm("입력하신 내용으로 글을 작성하시겠습니까?") == true)
		{
			document.writeForm.submit();	
		}
	});
});
</script>
</head>
<body>
<%@ include file="/include/navigation.jsp" %>

<div class="container">
   <h2>게시물 쓰기</h2>
   <form name="writeForm" id="writeForm" action="/board/writeProc.jsp" method="post">
   	  아이디 <input type="text" name="udId" id="udId"  maxlength="30" value="<%=user.getUdId()%>" style="ime-mode:inactive;" class="form-control mb-2" readonly />
      닉네임 <input type="text" name="udNickname" id="udNickname" maxlength="30" value="<%=user.getUdNickname()%>" style="ime-mode:inactive;" class="form-control mb-2" readonly />
      제목 <input type="text" name="bdTitle" id="bdTitle" maxlength="100" style="ime-mode:active;" class="form-control mb-2" placeholder="제목을 입력해주세요." required />
      <div class="form-group">
         내용 <textarea class="form-control" rows="10" name="bdContent" id="bdContent" style="ime-mode:active;" placeholder="내용을 입력해주세요" required></textarea>
      </div>
		
      <div class="form-group row">
      	<div class="col-sm-12">
      	    <input type="checkbox" id="bdSecret" name="bdSecret" value=""/>
    		<label for="secretCheckbox">비밀글 </label>
    	</div>	
        <div class="col-sm-12">
        	<button type="button" id="writeBtn" class="btn btn-primary" title="저장">저장</button>
        </div>
      </div>
   </form>
</div>

</body>
</html>