<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<% 
/* 사용자가 클릭한 게시글에 해당하는 id를 저장,
      비밀번호를 저장해  modify.jsp 파일에 post형식으로 데이터 전송 */

int b_id = Integer.parseInt(request.getParameter("b_id"));
%> 
<form action="modify.jsp" method="post" name="modifyform">
<input type="hidden" name="b_id" value="<%=b_id%>">
비밀번호를 입력하세요
<table border="1">
<tr> <td>비밀번호</td> <td><input type="text" name="b_password" value=""></td>  </tr>
<tr> <td colspan="2" align="center"><input type="submit" value="확인"><input type="reset" value="취소"></td></tr>

</table>
</form>
</body>
</html>