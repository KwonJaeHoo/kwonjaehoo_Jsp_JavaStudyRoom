<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%
	if(StringUtil.isEmpty(CookieUtil.getValue(request, "UD_ID")))
	{
%>

<nav class="navbar navbar-expand-sm bg-secondary navbar-dark mb-3"> 
	<ul class="navbar-nav"> 
	    <li class="nav-item"> 
	      <a class="nav-link" href="/"> 로그인</a> 
	    </li> 
	    <li class="nav-item"> 
	      <a class="nav-link" href="/user/signup.jsp">회원가입</a> 
	    </li> 
  </ul> 
</nav>

<%
	}
	else
	{
%>

<nav class="navbar navbar-expand-sm bg-secondary navbar-dark mb-3"> 
	<ul class="navbar-nav"> 
	    <li class="nav-item"> 
	      <a class="nav-link" href="/user/logoutProc.jsp"> 로그아웃</a> 
	    </li> 
	    <li class="nav-item"> 
	      <a class="nav-link" href="/board/list.jsp">게시판</a> 
	    </li>
	    <li class="nav-item"> 
	      <a class="nav-link" href="/mypage/mypage.jsp">마이페이지</a> 
	    </li>  
  </ul> 
</nav>

<%
	}
%>