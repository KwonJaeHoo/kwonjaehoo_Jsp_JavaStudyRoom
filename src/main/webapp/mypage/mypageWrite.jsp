<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%@ page import="com.sist.web.model.Board" %>
<%@ page import="com.sist.web.dao.BoardDao" %>

<%@ page import="com.sist.web.model.Paging" %>
<%@ page import="com.sist.web.model.BoardFileConfig" %>

<%@page import="java.util.List"%>

<%
	Logger logger = LogManager.getLogger("/mypage/mypageWrite.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieId = CookieUtil.getValue(request, "UD_ID");
	
	long curPage = HttpUtil.get(request, "curPage", 1);
	
	BoardDao boardDao = new BoardDao();
	Board boardSearch = new Board();
	List<Board> list = null;
	Paging paging = null;

	//boardSearch에 cookieId set -> boardDao method로 객체 넘겨서 값 가져옴
	boardSearch.setUdId(cookieId);
	long boardCountSelect = boardDao.boardCountSelect(boardSearch);
	
	if(boardCountSelect > 0)
	{
		paging = new Paging(boardCountSelect, BoardFileConfig.LIST_COUNT, BoardFileConfig.PAGE_COUNT, curPage);	
		
		boardSearch.setStartRow(paging.getStartRow());
		boardSearch.setEndRow(paging.getEndRow());
		
		list = boardDao.boardListSelect(boardSearch);
	}
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<script>
$(document).ready(function()
{
	$("#mypageWriteDeleteAllBtn").on("click", function()
	{
		if(confirm("게시글을 모두 삭제하시겠습니까?") == true)
		{
			document.mypageWriteDeleteAllForm.action = "/mypage/mypageWriteDeleteAll.jsp";
			document.mypageWriteDeleteAllForm.submit();
		}	
	});
});
function mypageWritePaging(curPage)
{
	document.mypageWriteForm.bdSeq = "";
	document.mypageWriteForm.curPage.value = curPage;
	document.mypageWriteForm.action = "/mypage/mypageWrite.jsp";
	document.mypageWriteForm.submit();
}	

function mypageWriteDelete(bdSeq)
{
	if(confirm("게시글을 삭제하시겠습니까?") == true)
	{
		document.mypageWriteForm.bdSeq.value = bdSeq;
		document.mypageWriteForm.action = "/board/delete.jsp";
		document.mypageWriteForm.submit();
	}	
}

function mypageWriteView(bdSeq)
{
	document.mypageWriteForm.bdSeq.value = bdSeq;
	document.mypageWriteForm.action = "/board/view.jsp";
	document.mypageWriteForm.submit();
}

</script>
</head>
<body>
<body>
<%@ include file="/include/navigation.jsp" %>
<div class="container">
   
   <div class="d-flex">
      <div style="width:50%;">
         <h2>내가 쓴 글</h2>
      </div>
    </div>
    
   <table class="table table-hover">
      <thead>
      <tr style="background-color: #dee2e6;">
         <th scope="col" class="text-center" style="width:10%">번호</th>
         <th scope="col" class="text-center" style="width:10%">제목</th>
         <th scope="col" class="text-center" style="width:25%">등록날짜</th>
         <th scope="col" class="text-center" style="width:25%">수정날짜</th>
         <th scope="col" class="text-center" style="width:10%">조회수</th>
         <th scope="col" class="text-center" style="width:10%">추천수</th>
         <th scope="col" class="text-center" style="width:10%"></th>
      </tr>
      </thead>
      <tbody>
<%
		if(list != null && list.size() > 0)
		{
			long startNum = paging.getStartNum();
			
			for(int i = 0; i < list.size(); i++)
			{	
				Board boardList = list.get(i);				
%>      
		      <tr>
		         <td class="text-center"><%=startNum%></td>
		         <td><a href="javascript:void(0)" onclick="mypageWriteView(<%=boardList.getBdSeq()%>)"><%=boardList.getBdTitle()%></a></td>
		         <td class="text-center"><%=boardList.getBdRegDate() %></td>
		         <td class="text-center"><%=boardList.getBdModDate() %></td>
		         <td class="text-center"><%=StringUtil.toNumberFormat(boardList.getBdReadCnt())%></td>
		         <td class="text-center"><%=StringUtil.toNumberFormat(boardList.getBdLikeCnt())%></td>
		         <td><button type="button" id="deleteBtn" class="btn btn-secondary mb-3" onclick="mypageWriteDelete(<%=boardList.getBdSeq()%>)">삭제</button> </td>
		      </tr>
<%
				startNum--;
			}
		}
		else
		{
%>
			<tr>
				<td colspan="7" class="text-center"> 작성 한 글이 없습니다. </td>
		    </tr>
<%		
		}
%>   
      </tbody>
      
      <tfoot>
      <tr>
            <td colspan="7"></td>
        </tr>
      </tfoot>
   </table>
   <nav>
      <ul class="pagination justify-content-center">
<%
	//값이 있으면, 페이징 보여줌
	if(paging != null)
	{
		if(paging.getPrevBlockPage() > 0)
		{
%>     
        	<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="mypageWritePaging(<%=paging.getPrevBlockPage()%>)">이전블럭</a></li>
<%
		}
		for(long i = paging.getStartPage(); i <= paging.getEndPage(); i++)
        {       
        	if(paging.getCurPage() != i)
        	{
%>
        		<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="mypageWritePaging(<%=i%>)"><%=i%></a></li>
<%
        	}
        	else
        	{   //현재 페이지
%>			
    	    	<li class="page-item active"><a class="page-link" href="javascript:void(0)" style="cursor:default;"><%=i%></a></li>
<%
        	}
        }
		if(paging.getNextBlockPage() > 0)
		{
%>
        	<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="mypageWritePaging(<%=paging.getNextBlockPage()%>)">다음블럭</a></li>
<%
		}	
	}
%>   
      </ul>
   </nav>
   
      <button type="button" id="mypageWriteDeleteAllBtn" class="btn btn-secondary mb-3">글 전체 삭제</button>
      
   <form name="mypageWriteForm" id="mypageWriteForm" method="post">
      	<input type="hidden" name="bdSeq" value="">
   		<input type="hidden" name="curPage" value="<%=curPage%>">

   </form>

   <form name="mypageWriteDeleteAllForm" id="mypageWriteDeleteAllForm" method="post">
   		<input type="hidden" name="udId" value="<%=cookieId%>">
   </form>
   
</div>
</body>
</html>