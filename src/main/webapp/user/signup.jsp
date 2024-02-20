<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%
	Logger logger = LogManager.getLogger("/user/signup.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieId = CookieUtil.getValue(request, "UD_ID");
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<script>

$(document).ready(function()
{	
	//모든 공백 체크 정규식
	var emptyCheck = /\s/g;
	
	//영문 대,소문자, 숫자로만 이루어진 n자리 정규식
	var idCheck = /^[a-zA-Z0-9]{4,16}$/;
	//특수문자, 영문 대,소문자,숫자 포함 형태의 n자리 이내의 암호 정규식
	var pwdCheck = /^.*(?=^.{8,32}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
	
	//이름 정규식
	var nameCheck = /^[가-힣]{2,16}$/;
	//닉네임정규식(한글 초성 및 모음은 허가하지 않음)
	var nicknameCheck =	/^(?=.*[a-z0-9가-힣])[a-z0-9가-힣]{2,16}$/;
	
	//Email 정규식
	var emailCheck = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
	
	//핸드폰번호 정규식
	var phoneCheck = /^\d{3}-\d{3,4}-\d{4}$/;

	$("#signupBtn").on("click", function()
	{
		//입력검증 - Id
		if($.trim($("#udId").val()).length <= 0)
		{
			alert("아이디를 입력해 주세요.");
			$("#udId").val("");
			$("#udId").focus();
			return;
		}
		//공백검증 - Id
		if(emptyCheck.test($("#udId").val()))
		{
			alert("아이디에 공백을 넣을 수 없습니다.");
			$("#udId").val("");
			$("#udId").focus();
			return;
		}
		//정규식검증 - Id
		if(!idCheck.test($("#udId").val()))
		{
			alert("아이디 형식이 올바르지 않습니다.");
			$("#udId").val("");
			$("#udId").focus();
			return;
		}
		
		//------------------------------------------	

		//입력검증 - Pwd1
		if($.trim($("#udPwd1").val()).length <= 0)
		{
			alert("비밀번호를 입력해 주세요.");
			$("#udPwd1").val("");
			$("#udPwd1").focus();
			return;
		}
		//공백검증 - Pwd1
		if(emptyCheck.test($("#udPwd1").val()))
		{
			alert("비밀번호에 공백을 넣을 수 없습니다.");
			$("#udPwd1").val("");
			$("#udPwd1").focus();
			return;
		}
		//정규식검증 - Pwd1
		if(!pwdCheck.test($("#udPwd1").val()))
		{
			alert("비밀번호 형식이 올바르지 않습니다.");
			$("#udPwd1").val("");
			$("#udPwd1").focus();
			return;
		}
		
		//------------------------------------------	

		//입력검증 - Pwd2
		if($.trim($("#udPwd2").val()).length <= 0)
		{
			alert("비밀번호 확인란을 입력해 주세요.");
			$("#udPwd2").val("");
			$("#udPwd2").focus();
			return;
		}
		
		//비밀번호 일치 검증 Pwd1 == Pwd2
		if($("#udPwd1").val() == $("#udPwd2").val())
		{
			//비밀번호가 일치하면 숨어있는 Pwd input에 대입
			$("#udPwd").val($("#udPwd1").val());
		}
		else
		{
			alert("비밀번호가 일치하지 않습니다.");
			$("#udPwd1").val("");
			$("#udPwd2").val("");
			$("#udPwd1").focus();
			return;
		}
		
		//------------------------------------------	

		//입력검증 - Name
		if($.trim($("#udName").val()).length <= 0)
		{
			alert("이름을 입력해 주세요.");
			$("#udName").val("");
			$("#udName").focus();
			return;
		}
		//공백검증 - Name
		if(emptyCheck.test($("#udName").val()))
		{
			alert("이름에 공백을 넣을 수 없습니다.");
			$("#udName").val("");
			$("#udName").focus();
			return;
		}
		//정규식검증 - Name
		if(!nameCheck.test($("#udName").val()))
		{
			alert("이름 형식이 올바르지 않습니다.");
			$("#udName").val("");
			$("#udName").focus();
			return;
		}
		
		//------------------------------------------	

		//입력검증 - Nickname
		if($.trim($("#udNickname").val()).length <= 0)
		{
			alert("닉네임을 입력해 주세요.");
			$("#udNickname").val("");
			$("#udNickname").focus();
			return;
		}
		//공백검증 - Nickname
		if(emptyCheck.test($("#udNickname").val()))
		{
			alert("닉네임에 공벡을 넣을 수 없습니다.");
			$("#udNickname").val("");
			$("#udNickname").focus();
			return;
		}
		//정규식검증 - Nickname
		if(!nicknameCheck.test($("#udNickname").val()))
		{
			alert("닉네임 형식이 올바르지 않습니다.");
			$("#udNickname").val("");
			$("#udNickname").focus();
			return;
		}
		
		//------------------------------------------	

		//입력검증 - Email
		if($.trim($("#udEmail").val()).length <= 0)
		{
			alert("이메일을 입력해 주세요.");
			$("#udEmail").val("");
			$("#udEmail").focus();
			return;
		}
		//공백검증 - Email
		if(emptyCheck.test($("#udEmail").val()))
		{
			alert("이메일에 공백을 넣을 수 없습니다.");
			$("#udEmail").val("");
			$("#udEmail").focus();
			return;
		}
		//정규식검증 - Email
		if(!emailCheck.test($("#udEmail").val()))
		{
			alert("이메일 형식이 올바르지 않습니다.");
			$("#udEmail").val("");
			$("#udEmail").focus();
			return;
		}
		
		//------------------------------------------	

		//입력검증 - Phone
		if($.trim($("#udPhone").val()).length <= 0)
		{
			alert("전화번호를 입력해 주세요.");
			$("#udPhone").val("");
			$("#udPhone").focus();
			return;
		}
		//공백검증 - Phone
		if(emptyCheck.test($("#udPhone").val()))
		{
			alert("전화번호에 공백을 넣을 수 없습니다.");
			$("#udPhone").val("");
			$("#udPhone").focus();
			return;
		}
		//정규식검증 - Phone
		if(!phoneCheck.test($("#udPhone").val()))
		{
			alert("전화번호 형식이 올바르지 않습니다.");
			$("#udPhone").val("");
			$("#udPhone").focus();
			return;
		}
		
		//------------------------------------------
		
		
		//------------------------------------------
		
		//jQuery용 AJAX통신
		$.ajax
		({
			type : "POST", 
			url : "/user/UserDataCheck.jsp",
			//데이터가 하나이상오면 {}
			data : 
			{
				udId : $("#udId").val(),
				udNickname : $("#udNickname").val(),
				udEmail : $("#udEmail").val(),
				udPhone : $("#udPhone").val()
			},
			datatype : "JSON",
			
			
			success : function(obj)
			{
				//json형식으로 파싱, obj 가져옴
				var data = JSON.parse(obj);
				
				if(data.flag == 0)
				{
					if(confirm("입력하신 내용으로 회원가입 하시겠습니까?") == true) 
					{
						document.signupForm.submit();
					}
				}
				else if(data.flag == 1)
				{
					alert("중복되는 아이디가 있습니다.");
					$("#udId").focus();
				}
				else if(data.flag == 2)
				{
					alert("중복되는 닉네임이 있습니다.");
					$("#udNickname").focus();
				}
				else if(data.flag == 3)
				{
					alert("중복되는 이메일이 있습니다.");
					$("#udEmail").focus();
				}
				else if(data.flag == 4)
				{
					alert("중복되는 전화번호가 있습니다.");
					$("#udPhone").focus();
				}
				else
				{
					alert("아이디, 닉네임, 이메일, 전화번호 값을 확인하세요.");
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
</head>
<body>
<% 	
	if(!StringUtil.isEmpty(cookieId))
	{
%>
<script>
		alert("잘못된 접근입니다.");
		location.href = "/index2.jsp";
</script>
<%
	}
	else
	{	
%>

<%@ include file="/include/navigation.jsp" %>

<div class="container">
    <div class="row mt-5">
       <h3>회원가입</h3>
    </div>
    <div class="row mt-2">
        <div class="col-12">
            <form id="signupForm" name="signupForm" action="/user/signupProc.jsp" method="post">
                <div class="form-group">
                    <label for="username">아이디</label> <small id="HelpInline" class="text-muted"> 아이디는 영문 대,소문자, 숫자를 사용하여 4~16자 입력해 주세요. </small>
                    <input type="text" class="form-control" id="udId" name="udId" placeholder="아이디" maxlength="16"> 
                </div>
                <div class="form-group">
                    <label for="username">비밀번호</label> <small id="HelpInline" class="text-muted"> 비밀번호는 특수문자 및 영문 대,소문자, 숫자를 포함하여 8~32자로 입력해 주세요. </small>
                    <input type="password" class="form-control" id="udPwd1" name="udPwd1" placeholder="비밀번호" maxlength="32">
                </div>
                <div class="form-group">
                    <label for="username">비밀번호 확인</label> <small id="HelpInline" class="text-muted"> 비밀번호를 다시한번 입력해 주세요. </small>
                    <input type="password" class="form-control" id="udPwd2" name="udPwd2" placeholder="비밀번호 확인" maxlength="32">
                </div>
                <div class="form-group">
                    <label for="username">이름</label> <small id="HelpInline" class="text-muted"> 이름은 최대 16자까지 입력 가능합니다. </small>
                    <input type="text" class="form-control" id="udName" name="udName" placeholder="이름" maxlength="16">
                </div>
                <div class="form-group">
                    <label for="username">닉네임</label> <small id="HelpInline" class="text-muted"> 닉네임은 2~16자로 입력해 주세요. </small>
                    <input type="text" class="form-control" id="udNickname" name="udNickname" placeholder="닉네임" maxlength="16">
                </div>
                <div class="form-group">
                    <label for="username">이메일</label> <small id="HelpInline" class="text-muted"> 이메일은 형식에 맞춰 입력해 주세요. ex) sist1030@domain.com </small>
                    <input type="text" class="form-control" id="udEmail" name="udEmail" placeholder="이메일" maxlength="32">
                </div>
      			<div class="form-group"> 
                    <label for="username">전화번호</label> <small id="HelpInline" class="text-muted"> 전화번호는 형식에 맞춰 입력해 주세요. ex) 010-1234-5678 </small>
                    <input type="text" class="form-control" id="udPhone" name="udPhone" placeholder="전화번호" maxlength="32">
                </div>
                <input type="hidden" id="udPwd" name="udPwd" value="">
                <button type="button" id="signupBtn" class="btn btn-primary">등록</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
<%
	}
%>