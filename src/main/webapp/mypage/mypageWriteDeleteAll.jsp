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

<%@page import="java.util.List"%>

<%
	Logger logger = LogManager.getLogger("/mypage/mypageWriteDeleteAll.jsp");
	HttpUtil.requestLogString(request, logger);

	String cookieId = CookieUtil.getValue(request, "UD_ID");
	
	String message = "";
	String redirectUrl = "/mypage/mypageWrite.jsp";
	
	String udId = HttpUtil.get(request, "udId");

	BoardDao boardDao = new BoardDao();
	Board board = new Board();
	board.setUdId(cookieId);
	List<Board> list = null;

	if(!StringUtil.isEmpty(udId))
	{
		if(StringUtil.equals(udId, cookieId))
		{
			board.setUdId(udId);
			list = boardDao.boardListSelect(board);
			
			if(list != null && list.size() > 0)
			{
				if(boardDao.boardDeleteAll(list) > 0)
				{
					message = "작성된 게시글이 모두 삭제되었습니다.";
				}
				else
				{
					message = "삭제 중 오류가 발생 하였습니다.";
				}
			}
			else
			{
				message = "삭제하려는 게시글이 존재하지 않습니다.";
			}
		}
		else
		{
			message = "삭제하려는 게시글의 작성자가 아닙니다.";
		}
	}
	else
	{
		message = "입력값이 잘못되었습니다.";
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
	location.href = "<%=redirectUrl%>";	
});
</script>
</head>
<body>
<%@ include file="/include/navigation.jsp" %>
</body>
</html>