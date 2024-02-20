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

<%@ page import="com.sist.web.model.Like" %>
<%@ page import="com.sist.web.dao.LikeDao" %>
<%
	Logger logger = LogManager.getLogger("/user/boardLikeCheck.jsp");
	HttpUtil.requestLogString(request, logger);
	
	long bdSeq = HttpUtil.get(request, "bdSeq", 0);
	String udId = HttpUtil.get(request, "udId");
		
	Like like = new Like();
	LikeDao likeDao = new LikeDao();
	
	like.setBdSeq(bdSeq);
	like.setUdId(udId);
	
	if(likeDao.boardLikeInsert(like) > 0)
	{
		response.getWriter().write("{\"flag\" : 0}");
	}
	else
	{
		response.getWriter().write("{\"flag\" : 1}");
	}
%>