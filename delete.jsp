<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<%
try{
	int b_id = Integer.parseInt(request.getParameter("b_id"));
	//jdbc 드라이버 설정
	Class.forName("com.mysql.jdbc.Driver");

	// DB 연동
	Connection pa = DriverManager.getConnection("jdbc:mysql://localhost:3306/bbsboard?useUnicode=true&characterEncoding=utf8", "pen", "1234");
	
	// SQL query문
	Statement pa1 = pa.createStatement();
	String sql="delete from mboard where b_id=" + b_id;  // test 테이블의 해당하는 id 데이터 삭제
	pa1.executeUpdate(sql);  // sql명령문 실행
	
	Statement pa2 = pa.createStatement(); 
	pa2.executeUpdate("set @num := 0");   // id 자동갱신을 해주기위한  mysql에서 변수 선언
	
	Statement pa3 = pa.createStatement();
	pa3.executeUpdate("update mboard set b_id = @num := (@num+1)");  // id를 0부터 자동갱신 하기
	
	response.sendRedirect("stlist.jsp"); 

	pa3.close();  
	pa2.close();
	pa1.close();
	
	// select count(id) from table이름 --> 학생수를 알수 잇음
}
catch(Exception e){
	out.println(e);
}


%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>