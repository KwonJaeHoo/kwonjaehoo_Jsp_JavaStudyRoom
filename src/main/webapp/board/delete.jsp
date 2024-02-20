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
	Logger logger = LogManager.getLogger("/board/delete.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieId = CookieUtil.getValue(request, "UD_ID");
	
	String message = "";
	String redirectUrl = "";
	
	long bdSeq = HttpUtil.get(request, "bdSeq", 0);
	
	if(StringUtil.equals(request.getHeader("Referer"), "http://jsr.co.kr:8088/mypage/mypageWrite.jsp"))
	{
		redirectUrl = "/mypage/mypageWrite.jsp";
	}
	else if (StringUtil.equals(request.getHeader("Referer"), "http://jsr.co.kr:8088/board/view.jsp"))
	{
		redirectUrl = "/board/list.jsp";
	}
	//get으로 치고 들어오는 경우
	else
	{
		redirectUrl = "/index2.jsp";
	}

		BoardDao boardDao = new BoardDao();
		Board board = boardDao.boardSelect(bdSeq);
		
		UserDao userDao = new UserDao();			
		//비밀글 작성자 조회, User 객체를 이용해서 조회 한 이유는 관리자인지 사용자인지 판단하기 위해서
		User user = userDao.userSelect(cookieId);
		
	if(board != null)
	{
		if(StringUtil.equals(cookieId, board.getUdId()) || StringUtil.equals("A", user.getUdAuth()))
		{
			if(boardDao.boardDelete(bdSeq) > 0)
			{
				message = "게시글이 삭제되었습니다.";
			}
			else
			{
				message = "게시글 삭제 중 오류가 발생 하였습니다.";
			}
		}
		else
		{
			message = "게시글의 작성자가 아닙니다.";
		}
	}
	else
	{
		message = "존재하지 않는 글 입니다.";
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

</body>
</html>