<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.web.dao.UserDao" %>

<%
	Logger logger = LogManager.getLogger("/user/UserDataCheck.jsp");
	HttpUtil.requestLogString(request, logger);
	
	//ajax 통신 할 때 보내는 data와 이름이 같아야함, userId
	String udId = HttpUtil.get(request, "udId");
	String udNickname = HttpUtil.get(request, "udNickname");
	String udEmail = HttpUtil.get(request, "udEmail");
	String udPhone = HttpUtil.get(request, "udPhone");
	
	if(StringUtil.equals(request.getHeader("Referer"), "http://jsr.co.kr:8088/user/signup.jsp"))
	{
		if(!StringUtil.isEmpty(udId) && !StringUtil.isEmpty(udNickname) && !StringUtil.isEmpty(udEmail) && !StringUtil.isEmpty(udPhone))
		{
			UserDao userDao = new UserDao();

			if(userDao.udIdCount(udId) == 0 && userDao.udNicknameCount(udNickname) == 0 && userDao.udEmailCount(udEmail) == 0 && userDao.udPhoneCount(udPhone) == 0)
			{
				response.getWriter().write("{\"flag\" : 0}");
			}
			else if(userDao.udIdCount(udId) != 0)
			{
				response.getWriter().write("{\"flag\" : 1}");
			}
			else if(userDao.udNicknameCount(udNickname) != 0)
			{
				response.getWriter().write("{\"flag\" : 2}");
			}
			else if(userDao.udEmailCount(udEmail) != 0)	
			{
				response.getWriter().write("{\"flag\" : 3}");
			}
			else if(userDao.udPhoneCount(udPhone) != 0)
			{
				response.getWriter().write("{\"flag\" : 4}");
			}
		}
		else
		{
			//Id, NickName, Email, Phone 값이 없는경우 
			response.getWriter().write("{\"flag\" : -1}");
		}
	}
	else if(StringUtil.equals(request.getHeader("Referer"), "http://jsr.co.kr:8088/mypage/mypageUpdate.jsp"))
	{
		if(!StringUtil.isEmpty(udNickname) && !StringUtil.isEmpty(udEmail) && !StringUtil.isEmpty(udPhone))
		{
			UserDao userDao = new UserDao();
			User user = userDao.userSelect(udId);

			if(userDao.udNicknameCount(udNickname) != 0)
			{
				if(!StringUtil.equals(user.getUdNickname(), udNickname))
				{
					response.getWriter().write("{\"flag\" : 1}");
					return;
				}
			}
			if(userDao.udEmailCount(udEmail) != 0)	
			{
				if(!StringUtil.equals(user.getUdEmail(), udEmail))
				{
					response.getWriter().write("{\"flag\" : 2}");
					return;
				}
			}
			if(userDao.udPhoneCount(udPhone) != 0)
			{
				if(!StringUtil.equals(user.getUdPhone(), udPhone))
				{
					response.getWriter().write("{\"flag\" : 3}");
					return;
				}
			}
			if(userDao.udNicknameCount(udNickname) == 0 && userDao.udEmailCount(udEmail) == 0 && userDao.udPhoneCount(udPhone) == 0)
			{
				response.getWriter().write("{\"flag\" : 0}");
				return;
			}
			
			//기존값과 전부 동일하면 0
			response.getWriter().write("{\"flag\" : 0}");
		}
		else
		{
			//NickName, Email, Phone 값이 없는경우 
			response.getWriter().write("{\"flag\" : -1}");
		}
	}
%>