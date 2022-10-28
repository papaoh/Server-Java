<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<% 
try{ // 예외처리문
String b_name = request.getParameter("b_name");     // 수정된 이름을 저장하기위한 변수 선언
String b_title = request.getParameter("b_title");   // 수정된 내용을 저장하기위한 변수 선언
String b_mail = request.getParameter("b_mail");     // 수정된 이메일을 저장하기위한 변수 선언
String b_content = request.getParameter("b_content");    // 수정된 내용을 저장하기위한 변수 선언
String b_pwd = request.getParameter("b_pwd");       // 수정된 비밀번호을 저장하기위한 변수 선언

int b_id = Integer.parseInt(request.getParameter("b_id"));   // ID을 저장하기위한 변수 선언
out.println("해당 게시글번호:" + b_id + "<br />");


//jdbc 드라이버 설정
Class.forName("com.mysql.jdbc.Driver");

// DB 연동
Connection pa = DriverManager.getConnection("jdbc:mysql://localhost:3306/bbsboard?useUnicode=true&characterEncoding=utf8", "pen", "1234");

// SQL query문
Statement pa1 = pa.createStatement();
String sql="update mboard set b_name='"+b_name +"', b_title='"+ b_title +"', b_mail='"+ b_mail +"', b_content='"+ b_content +"', b_pwd='"+ b_pwd +"' where b_id="+b_id;
out.println(sql);
pa1.executeUpdate(sql);  // 수정된 내용을 DB에 저장하는 쿼리문 실행

response.sendRedirect("flist.jsp");

pa1.close();
}
catch(Exception e){
	out.println(e);
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정 처리 페이지</title>
</head>
<body>
게시글 수정 완료되었습니다.

</body>
</html>