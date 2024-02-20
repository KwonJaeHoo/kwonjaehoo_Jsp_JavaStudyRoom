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

	Logger logger = LogManager.getLogger("/board/writeProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieId = CookieUtil.getValue(request, "UD_ID");
	
	String message = "";
	String redirectUrl = "/board/write.jsp";
	boolean writeProcSuccess = false;
	
	String udId = HttpUtil.get(request, "udId");
	String bdTitle = HttpUtil.get(request, "bdTitle", "");
	String bdContent = HttpUtil.get(request, "bdContent", "");
	String bdSecret = HttpUtil.get(request, "bdSecret", "N");
	
	UserDao userDao = new UserDao();
	User user = null;

	if(!StringUtil.isEmpty(bdTitle) && !StringUtil.isEmpty(bdContent) && !StringUtil.isEmpty(udId))
	{
		user = userDao.userSelect(udId);
		
		if(user != null)
		{
			if(StringUtil.equals(cookieId, user.getUdId()))
			{
				BoardDao boardDao = new BoardDao();
				Board board = new Board();
				
				board.setUdId(user.getUdId());
				board.setUdNickname(user.getUdNickname());
				board.setBdTitle(bdTitle);
				board.setBdContent(bdContent);
				board.setBdSecret(bdSecret);
				
				if(boardDao.boardInsert(board) > 0)
				{
					message = "게시글 작성이 완료되었습니다.";
					writeProcSuccess = true;
				}
				else
				{
					message = "게시글 작성 중 오류가 발생 하였습니다.";
				}
			}
			else
			{
				message = "작성하려는 아이디값과 현재 로그인 아이디값이 다릅니다.";
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
	
	if(writeProcSuccess)
	{
		redirectUrl = "/board/list.jsp";
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
	if(writeProcSuccess)
	{
%>
		alert("<%=message%>");	
		location.href = "<%=redirectUrl%>";
<%
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
<%@ include file="/include/navigation.jsp" %>
</body>
</html>