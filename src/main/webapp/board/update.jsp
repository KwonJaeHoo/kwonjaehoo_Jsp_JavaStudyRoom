<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.web.dao.UserDao" %>

<%@ page import="com.sist.web.model.Board" %>
<%@ page import="com.sist.web.dao.BoardDao" %>

<%
	Logger logger = LogManager.getLogger("/board/update.jsp");
	HttpUtil.requestLogString(request, logger);

	String cookieId = CookieUtil.getValue(request, "UD_ID");

	long bdSeq = HttpUtil.get(request, "bdSeq", 0);

	boolean updateLoad = false;
	
	BoardDao boardDao = new BoardDao();
	Board board = boardDao.boardSelect(bdSeq);
	


	if(board != null)	
	{
		if(StringUtil.equals(cookieId, board.getUdId()))
		{
			updateLoad = true;		
		}
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
	if(board == null)
	{	
%>	
		alert("존재하지 않는 글 입니다.");	
		location.href = "/board/list.jsp";
		return;
<%	
	}
	else if(!updateLoad)
	{
%>
		alert("수정 할 수 있는 권한이 없습니다.");	
		location.href = "/board/list.jsp";
		return;
<%
	}
	else
	{	
%>
		$("#updateBtn").on("click", function()
		{		
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
					
			if(confirm("입력하신 내용으로 글을 수정하시겠습니까?") == true)
			{
				document.updateForm.submit();	
			}
		});
<%
	}
%>
});
</script>
</head>
<% 
	if(updateLoad)
	{
%>
<body>
<%@ include file="/include/navigation.jsp" %>

<div class="container">
   <h2>게시물 수정</h2>
   <form name="updateForm" id="updateForm" action="/board/updateProc.jsp" method="post">
   		<input type="hidden" name="bdSeq" value="<%=board.getBdSeq()%>"/>
   	  아이디 <input type="text" name="udId" id="udId"  maxlength="30" value="<%=board.getUdId()%>" style="ime-mode:inactive;" class="form-control mb-2" readonly />
      닉네임 <input type="text" name="udNickname" id="udNickname" maxlength="30" value="<%=board.getUdNickname()%>" style="ime-mode:inactive;" class="form-control mb-2" readonly />
      제목 <input type="text" name="bdTitle" id="bdTitle" maxlength="100" value="<%=board.getBdTitle()%>" style="ime-mode:active;" class="form-control mb-2" placeholder="제목을 입력해주세요." required />
      <div class="form-group">
         내용 <textarea class="form-control" rows="10" name="bdContent" id="bdContent"  style="ime-mode:active;" placeholder="내용을 입력해주세요" required><%=board.getBdContent()%></textarea>
      </div>
		
      <div class="form-group row">
        <div class="col-sm-12">
        	<button type="button" id="updateBtn" class="btn btn-primary" title="저장">저장</button>
        </div>
      </div>
   </form>
</div>
</body>
</html>

<%
	}
%>