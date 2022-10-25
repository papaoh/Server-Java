<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<%
try{
	int b_id = Integer.parseInt(request.getParameter("b_id"));
	String b_password = request.getParameter("b_password");  // 사용자가 입력한 패스워드를 저장할 공간
	String password; // DB에 저장된 패스워드를 저장할 변수
	
	//jdbc 드라이버 설정
	Class.forName("com.mysql.jdbc.Driver");

	// DB 연동
	Connection pa = DriverManager.getConnection("jdbc:mysql://localhost:3306/bbsboard?useUnicode=true&characterEncoding=utf8", "pen", "1234");
	// 쿼리문 처리
	Statement pb1= pa.createStatement();    
	String query1 = "select b_pwd from mboard where b_id = " + b_id;  // 해당하는 id의 비밀번호 검색
	// out.print(query1);   
	ResultSet pb2 = pb1.executeQuery(query1);  
	if(pb2.next()){  // 만약 해당하는 id에 비밀번호가 있으면
		password = pb2.getString(1);  // 패스워드 변수에 저장
	} else{
		password = "null";   // 패스워드는 null값으로 저장
	}
	pb2.close();
	pb1.close();
	
	if(password.equals(b_password)){  //  만약 입력한 패스워드가 동일하다면
	   
	   // SQL query문
	   Statement pa1 = pa.createStatement();
	   String sql="delete from mboard where b_id=" + b_id;  // test 테이블의 해당하는 id 데이터 삭제
	   pa1.executeUpdate(sql);  // sql명령문 실행
	
	   Statement pa2 = pa.createStatement(); 
	   pa2.executeUpdate("set @num := 0");   // id 자동갱신을 해주기위한  mysql에서 변수 선언
	
	   Statement pa3 = pa.createStatement();
	   pa3.executeUpdate("update mboard set b_id = @num := (@num+1)");  // id를 0부터 자동갱신 하기
	   
	   pa3.close();  
	   pa2.close();
	   pa1.close();
	   %>
	   <script> 
	    alert("게시글 삭제 완료");
	    location.href="flist.jsp";   
	    </script>
	   <% 
	   // response.sendRedirect("flist.jsp"); 
	   
	} else{  // 만약 동일하지 않다면   비밀번호가 틀렸다는 알림을 출력 후 페이지 이동%> 
	    <script> 
	    alert("비밀번호 불일치");
	    location.href="flist.jsp";   
	    </script>
	<%
	}
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