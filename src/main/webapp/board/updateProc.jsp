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
	Logger logger = LogManager.getLogger("/board/updateProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String message = "";
	String redirectUrl = "/board/view.jsp";
	
	String cookieId = CookieUtil.getValue(request, "UD_ID");
	
	long bdSeq = HttpUtil.get(request, "bdSeq", 0);
	String udId = HttpUtil.get(request, "udId");
	String bdTitle = HttpUtil.get(request, "bdTitle", "");
	String bdContent = HttpUtil.get(request, "bdContent", "");
	
	BoardDao boardDao = new BoardDao();
	Board board = boardDao.boardSelect(bdSeq);
	
	UserDao userDao = new UserDao();
	User user = userDao.userSelect(cookieId);
	
	if(!StringUtil.isEmpty(bdTitle) && !StringUtil.isEmpty(bdContent) && !StringUtil.isEmpty(udId))
	{
		if(board != null)
		{	
			if(user != null)
			{
				if(StringUtil.equals(cookieId, board.getUdId()))
				{
					board.setBdTitle(bdTitle);
					board.setBdContent(bdContent);
					
					if(boardDao.boardUpdate(board) > 0)
					{
						message = "게시글 수정이 완료되었습니다.";
					}
					else
					{
						message = "게시글 수정 중 오류가 발생 하였습니다.";
					}
				}
				else
				{
					message = "수정하려는 아이디값과 현재 로그인 아이디값이 다릅니다.";
				}
			}
			else
			{
				message = "존재하지 않는 사용자입니다.";
			}
		}
		else
		{
			message = "존재하지 않는 게시글입니다.";
		}
	}	
	else
	{
		message = "입력 값이 잘못 되었습니다.";
	}
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<script>
$(document).ready(function()
{
	alert("<%=message%>");
	document.updateForm.action = "<%=redirectUrl%>";
	document.updateForm.submit();

});
</script>
</head>
<body>
<%@ include file="/include/navigation.jsp" %>
	<form name="updateForm" id="updateForm" method="post">
		<input type="hidden" name="bdSeq" value="<%=bdSeq%>">
	</form>
</body>
</html>