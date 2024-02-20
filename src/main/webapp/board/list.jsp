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

<%@ page import="com.sist.web.model.Paging" %>
<%@ page import="com.sist.web.model.BoardFileConfig" %>

<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>

<%
	Logger logger = LogManager.getLogger("/board/list.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieId = CookieUtil.getValue(request, "UD_ID");

	boolean searchSecret = false;
	
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	String searchSort = HttpUtil.get(request, "searchSort", "1");
	long curPage = HttpUtil.get(request, "curPage", 1);

	UserDao userDao = new UserDao();
	BoardDao boardDao = new BoardDao();
	
	//게시글 조회용
	Board boardSearch = new Board();
	List<Board> list = null;
	
	//공지사항용 
	Board boardNotice = new Board();
	List<Board> listCheck = null;
	
	Paging paging = null;
	
	long n = 0;
	
	//1 nickname 2 title 3 content
	if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue))
	{
		if(StringUtil.equals("1", searchType))
		{
			boardSearch.setUdNickname(searchValue);
		}
		else if(StringUtil.equals("2", searchType))
		{
			boardSearch.setBdTitle(searchValue);
		}
		else if(StringUtil.equals("3", searchType))
		{
			boardSearch.setBdContent(searchValue);
		}	
	}
	boardSearch.setBdSort(searchSort);
	
	
	logger.debug("dddddddddddddddddddddddddddddddddddddddddddddd"+searchSort);


	
	/*
		페이징 - 페이징 인스턴스 변수를 생성, 단 객체는 x (null)
		board의 총 갯수(count)를 받을 long변수 선언, 
		count를 받아온 값이 0보다 크면  페이징 객체를 생성(new Paging())
		페이징 객체는 생성자 4개필요함, 
		
		이후 board인스턴스 변수에 StartRow, EndRow를 성정해줌
		받아온 값으로 list 인스턴스 변수에 Dao로 조회해서 값 받아오기
	*/
	
	
	//글 2번 select함
	listCheck = boardDao.boardListSelect(boardNotice);
	List<Board> listAdmin = new ArrayList<>();
	
	for(int i = 0; i < listCheck.size(); i++)
	{
		Board boardCheck = listCheck.get(i);
		User userCheck = userDao.userSelect(boardCheck.getUdId());
		
		if(StringUtil.equals(userCheck.getUdAuth(), "A"))
		{
			listAdmin.add(boardCheck);
		}
	}
	
	//페이징 객체 생성
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
	$("#searchTypeSelect").change(function()
	{
		$("#searchValueSelect").val("");
	});
	
	$("#searchSortSelect").change(function()
	{
		document.listForm.searchSort.value = $("#searchSortSelect").val();
		document.listForm.action = "/board/list.jsp";
		document.listForm.submit();
	});
	
    $("#searchBtn").on("click", function()
   	{	
		if($("#searchTypeSelect").val() != "")
    	{
    		if($.trim($("#searchValueSelect").val()) == "")
    	    {
    	    	alert("조회 값을 입력하세요.");
    	    	$("#searchValueSelect").val("");
    	    	$("#searchValueSelect").focus();
    	    	return;
    	    }
    	}
    	document.listForm.bdSeq.value = "";
    	document.listForm.searchType.value = $("#searchTypeSelect").val();
    	document.listForm.searchValue.value = $("#searchValueSelect").val();
    	
    	//처리안하면 페이지 2~5에 갔을 때 검색결과 페이지도 2~5페이지에 있어서 검색결과가 안보임
    	document.listForm.curPage.value = "";
    	document.listForm.action = "/board/list.jsp";
    	document.listForm.submit();
	});
    
    $("#writeBtn").on("click", function()
   	{
   		document.listForm.bdSeq.value = "";
    	document.listForm.action = "/board/write.jsp";
    	document.listForm.submit();
    });
});

function listPaging(curPage)
{
	document.listForm.bdSeq = "";
	document.listForm.curPage.value = curPage;
	document.listForm.action = "/board/list.jsp";
	document.listForm.submit();
}	

function listView(bdSeq)
{
	document.listForm.bdSeq.value = bdSeq;
	document.listForm.action = "/board/view.jsp";
	document.listForm.submit();
}

</script>
</head>
<body>
<%@ include file="/include/navigation.jsp" %>
<div class="container">
   
   <div class="d-flex">
      <div style="width:50%;">
         <h2>게시판</h2>
      </div>
      
      <div class="ml-auto input-group" style="width:50%;">
         <select name="searchTypeSelect" id="searchTypeSelect" class="custom-select" style="width:auto;">
            <option value="">조회 항목</option>
            <option value="1" <% if(StringUtil.equals(searchType, "1")) %> selected <%%>>닉네임</option>
            <option value="2" <% if(StringUtil.equals(searchType, "2")) %> selected <%%>>제목</option>
            <option value="3" <% if(StringUtil.equals(searchType, "3")) %> selected <%%>>내용</option>
         </select>
         <input type="text" name="searchValueSelect" id="searchValueSelect" value="<%=searchValue%>" class="form-control mx-1" maxlength="20" style="width:auto;ime-mode:active;" placeholder="조회값을 입력하세요." />
         <button type="button" id="searchBtn" class="btn btn-secondary mb-3 mx-1">조회</button>
      </div>
    </div>
    
   <table class="table table-hover">
      <thead>
      <tr style="background-color: #dee2e6;">
         <th scope="col" class="text-center" style="width:8%">번호</th>
         <th scope="col" class="text-center" style="width:15%">제목</th>
         <th scope="col" class="text-center" style="width:10%">닉네임</th>
         <th scope="col" class="text-center" style="width:15%">등록날짜</th>
         <th scope="col" class="text-center" style="width:15%">수정날짜</th>
         <th scope="col" class="text-center" style="width:8%">조회수</th>
         <th scope="col" class="text-center" style="width:8%">추천수</th>
         <th scope="col" class="text-center" style="width:11%">비밀글여부</th>
      </tr>
      </thead>
      <tbody>
<%

	//공지사항 검색용
	if(listAdmin != null && listAdmin.size() > 0)
	{
		long startNum = 1;
		
		for(int i = listAdmin.size()-1; i >= 0 ; i--)
		{
			Board boardList = listAdmin.get(i);
%>
				<tr bgcolor="#bbdefb">
			        <td class="text-center"><%=startNum%></td>
			        <td class="text-center"><a href="javascript:void(0)" onclick="listView(<%=boardList.getBdSeq()%>)"><%=boardList.getBdTitle()%></a></td>
			        <td class="text-center"><%=boardList.getUdNickname() %></td>
			        <td class="text-center"><%=boardList.getBdRegDate() %></td>
			        <td class="text-center"><%=boardList.getBdModDate() %></td>
			        <td class="text-center"><%=StringUtil.toNumberFormat(boardList.getBdReadCnt())%></td>
			        <td class="text-center"><%=StringUtil.toNumberFormat(boardList.getBdLikeCnt())%></td>
			    	<td class="text-center"><%=boardList.getBdSecret()%></td>
				</tr>
<%
			startNum++;
		}
	}
%>    
      </tbody>
      <tbody>
<%

	//전체 글 검색용
	if(list != null && list.size() > 0)
	{
		long startNum = paging.getStartNum();
			
		for(int i = 0; i < list.size(); i++)
		{	
			Board boardList = list.get(i);
				
			User user = userDao.userSelect(cookieId);
			User userAuthCheck = userDao.userSelect(boardList.getUdId());
			
			if(StringUtil.equals(searchType, "3"))
			{
				if(StringUtil.equals(boardList.getBdSecret(), "Y"))
				{
					if(StringUtil.equals(cookieId, boardList.getUdId()))
					{
						searchSecret = true;
					}
					else if(StringUtil.equals(user.getUdAuth(), "A"))
					{
						searchSecret = true;
					}
				}
				else
				{
					searchSecret = true;
				}
			}
			else
			{
				searchSecret = true;
			}
			
			if(searchSecret)
			{
%>      
				<tr>
			        <td class="text-center"><%=startNum%></td>
			        <td class="text-center"><a href="javascript:void(0)" onclick="listView(<%=boardList.getBdSeq()%>)"><%=boardList.getBdTitle()%></a></td>
			        <td class="text-center"><%=boardList.getUdNickname() %></td>
			        <td class="text-center"><%=boardList.getBdRegDate() %></td>
			        <td class="text-center"><%=boardList.getBdModDate() %></td>
			        <td class="text-center"><%=StringUtil.toNumberFormat(boardList.getBdReadCnt())%></td>
			        <td class="text-center"><%=StringUtil.toNumberFormat(boardList.getBdLikeCnt())%></td>
			    	<td class="text-center"><%=boardList.getBdSecret()%></td>
				</tr>
<%		
			}
				startNum--;
		}
		if(!searchSecret)
		{
%>			<tr>
				<td colspan="8" class="text-center"> 검색 결과가 없습니다. </td>
		   	</tr>
<%			    
		}
	}
	else
	{
%>
			<tr>
				<td colspan="8" class="text-center"> 검색 결과가 없습니다. </td>
		    </tr>
<%		
	}
%>   
      </tbody>
      <tfoot>
      <tr>
            <td colspan="8"></td>
        </tr>
      </tfoot>
   </table>
   
      <span style="float:right;">
	      <select name="searchSortSelect" id="searchSortSelect" class="custom-select" style="width:auto;">
	            <option value="1" <% if(StringUtil.equals(searchSort, "1")) %> selected <%%>>최신</option>
	            <option value="2" <% if(StringUtil.equals(searchSort, "2")) %> selected <%%>>추천</option>
	            <option value="3" <% if(StringUtil.equals(searchSort, "3")) %> selected <%%>>조회</option>
	      </select>
	  </span>
   <nav>
      <ul class="pagination justify-content-center">
<%
	//값이 있으면, 페이징 보여줌
	if(paging != null)
	{
		if(paging.getPrevBlockPage() > 0)
		{
%>     
        	<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="listPaging(<%=paging.getPrevBlockPage()%>)">이전블럭</a></li>
<%
		}
		for(long i = paging.getStartPage(); i <= paging.getEndPage(); i++)
        {       
        	if(paging.getCurPage() != i)
        	{
%>
        		<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="listPaging(<%=i%>)"><%=i%></a></li>
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
        	<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="listPaging(<%=paging.getNextBlockPage()%>)">다음블럭</a></li>
<%
		}	 
	}
%>   
      </ul>

   </nav>
   
   <button type="button" id="writeBtn" class="btn btn-secondary mb-3">글쓰기</button>

   <form name="listForm" id="listForm" method="post">
   		<input type="hidden" name="bdSeq" value="">
   		<input type="hidden" name="searchType" value="<%=searchType%>">
   		<input type="hidden" name="searchValue" value="<%=searchValue%>">
   		<input type="hidden" name="curPage" value="<%=curPage%>">
   		<input type="hidden" name="searchSort" value="<%=searchSort%>">
   </form>
</div>
	
	
</body>
</html>