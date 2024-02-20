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
	//board 객체조회 - bdSecert이 Y이면 return
	Logger logger = LogManager.getLogger("/board/view.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieId = CookieUtil.getValue(request, "UD_ID");
	
	boolean viewSuccess = false;
	
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long bdSeq = HttpUtil.get(request, "bdSeq", 0);
	long curPage = HttpUtil.get(request, "curPage", 1);
	
	BoardDao boardDao = new BoardDao();
	Board board = boardDao.boardSelect(bdSeq);
	
	UserDao userDao = new UserDao();			
	//비밀글 작성자 조회, User 객체를 이용해서 조회 한 이유는 관리자인지 사용자인지 판단하기 위해서
	User user = userDao.userSelect(cookieId);
	
	//Seq로 글이 있는지 조회 함, 글이 있으면

	if(board != null)
	{
		//조회한 글이 비밀글인가? 확인
		if(StringUtil.equals("Y", board.getBdSecret()))
		{
			if(user != null)
			{
				//user.getUdId == cookieId, board.getUdId와 같은지 조회, 또는 권한이 A(Admin) 인가? 에 대해 둘 중 하나만 참이여도 읽기가능
				if(StringUtil.equals(user.getUdId(), board.getUdId()) || StringUtil.equals("A", user.getUdAuth()))
				{
					viewSuccess = true;
					boardDao.boardReadCount(bdSeq);
				}
			}
		}
		else
		{
			viewSuccess = true;
			boardDao.boardReadCount(bdSeq);
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
		document.viewBackForm.action = "/board/list.jsp";
		document.viewBackForm.submit();
		return;
<%	
	}
	else if(!viewSuccess)
	{
%>
		alert("읽을 수 있는 권한이 없습니다.");	
		document.viewBackForm.action = "/board/list.jsp";
		document.viewBackForm.submit();
		return;
<%
	}

	else if(StringUtil.equals(cookieId, board.getUdId()))
	{
%>
		$("#viewUpdateBtn").on("click", function()
		{
			document.viewForm.action="/board/update.jsp";
			document.viewForm.submit();  				
		});
				
		$("#viewDeleteBtn").on("click", function()
		{
			if(confirm("게시글을 삭제하시겠습니까?") == true)
			{
				document.viewForm.action="/board/delete.jsp";
				document.viewForm.submit();
			}
		});
<%
	}
	else if(StringUtil.equals("A", user.getUdAuth()))
	{
%>
		$("#viewDeleteBtn").on("click", function()
		{
			if(confirm("게시글을 삭제하시겠습니까?") == true)
			{
				document.viewForm.action="/board/delete.jsp";
				document.viewForm.submit();
			}
		});
<%
	}
%>
	

});
</script>
</head>

<% 
	if(viewSuccess)
	{		
%>
<script>
$(document).ready(function()
{
	$("#viewLikeUpdateBtn").on("click", function()
	{
		$.ajax
		({
			type : "POST", 
			url : "/board/boardLikeCheck.jsp",
			//데이터가 하나이상오면 {}
			data : 
			{
				udId : $("#udId").val(),
				bdSeq : $("#bdSeq").val()
			},
			datatype : "JSON",
			
			success : function(obj)
			{
				//json형식으로 파싱, obj 가져옴
				var data = JSON.parse(obj);
				var like = <%=board.getBdLikeCnt()+1%>;
				
				if(data.flag == 0)
				{
					$("#viewLike").val("");
					$("#viewLike").html(like);
					
					alert("게시글이 추천 되었습니다.");
				}
				else if(data.flag == 1)
				{
					alert("이미 추천한 게시글 입니다.");
				}
			},
					//500error
			error : function(xhr, status, error)
			{
				alert("중복체크 오류");
			}
		});
	});
});
</script>
<body>
<%@ include file="/include/navigation.jsp" %>
<div class="container">
   <h2>게시물 보기</h2>
   <div class="row" style="margin-right:0; margin-left:0;">
      <table class="table">
         <thead>
            <tr class="table-active">
               <th scope="col" style="width:60%">
                  <%=board.getBdTitle() %><br/>
                  <%=board.getUdNickname() %>&nbsp;&nbsp;&nbsp;
               </th>
               <th scope="col" style="width:40%" class="text-right">
                  조회 : <%=StringUtil.toNumberFormat(board.getBdReadCnt()+1) %><br/> 
                  <%=board.getBdRegDate()%><br />
                  <%=board.getBdModDate()%>
               </th>
            </tr>
         </thead>
         <tbody>
            <tr>						
            	<%--filter : 특수문자 필터링 --%> <%--StringUtil.replace , httpUtil.filter로 받아온 값에서 \n을 br로 변경 --%>
               <td colspan="2"><pre><%= StringUtil.replace(HttpUtil.filter(board.getBdContent()), "\n", "<br />")%></pre></td>
            </tr>
         </tbody>
         <tfoot>
         <tr>
               <td colspan="2"></td>
           </tr>
         </tfoot>
      </table>
   </div>
     
     <div align="right">
     	<span id="viewLike"> <%=board.getBdLikeCnt() %></span><br />
     	<button type="button" id="viewLikeUpdateBtn" class="btn btn-secondary" style="float:right">추천</button>
     </div> 

<%
	if(StringUtil.equals(cookieId, board.getUdId()))
	{
%>
   		<button type="button" id="viewUpdateBtn" class="btn btn-secondary">수정</button>
   		<button type="button" id="viewDeleteBtn" class="btn btn-secondary">삭제</button>
<% 
	}
	else if(StringUtil.equals("A", user.getUdAuth()))
	{
%>
		<button type="button" id="viewDeleteBtn" class="btn btn-secondary">삭제</button>
<%
	}
%>  
	<br /><br />
	
   	<form name="viewForm" id="viewForm" method="post">
   		<input type="hidden" name="bdSeq" id="bdSeq" value="<%=bdSeq%>">
   		<input type="hidden" name="udId" id="udId" value="<%=cookieId%>">
	</form>
	
   <br/><br/>
</div>


</body>
</html>
<%
	}
	else
	{
%>
<body>
<%@ include file="/include/navigation.jsp" %>
	<form name="viewBackForm" id="viewForm" method="post">   		
   		<input type="hidden" name="searchType" value="<%=searchType%>">
   		<input type="hidden" name="searchValue" value="<%=searchValue%>">
   		<input type="hidden" name="curPage" value="<%=curPage%>">
	</form>
</body>
<%
	}
%>