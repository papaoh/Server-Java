<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상세보기 페이지</title>
</head>
<body>
<%
try{
	// DB의 데이터를 저장할 객체 변수 선언
	String b_name, b_title, b_mail, b_date, b_filename, b_filesize, b_content;
	int b_id = Integer.parseInt(request.getParameter("b_id"));
	int b_view;
	
	out.println("선택번호 : " + b_id + "<br />");  // 선택된 ID 출력
	
	Class.forName("com.mysql.jdbc.Driver");  //DB연결을 위한jdbc 드라이버 설정
	Connection pa = DriverManager.getConnection("jdbc:mysql://localhost:3306/bbsboard?useUnicode=true&characterEncoding=utf8", "pen", "1234");
	// 실제 DB와 연결
	Statement pb1 = pa.createStatement();  // 조회수 증가를 위한 쿼리문 설정
	String sql="update mboard set b_view = b_view + 1 where b_id = " + b_id;  // 조회수 증가 쿼리문
	pb1.executeUpdate(sql);  // 쿼리문 실행
	
	Statement pa1 = pa.createStatement();
	ResultSet pa2 = pa1.executeQuery("select * from mboard where b_id = " + b_id);  // 상세보기를 위한 데이터 선택
	if(pa2.next()){
		b_id = pa2.getInt(1);  // ID
		b_name = pa2.getString(2);  // 작성자
		b_title = pa2.getString(3); // 제목
		b_mail = pa2.getString(4);  // 이메일
		b_content = pa2.getString(5); // 내용
		b_date = pa2.getString(6);  // 작성시간
		b_view = pa2.getInt(7);  // 조회수
		b_filename =  pa2.getString(9);  // 파일이름
		b_filesize =  pa2.getString(10);  // 파일크기
		%>
	<p> 
	<div> 게시글 상세 정보 내용	 </div>
	<table border="1" cellspacing="0" aellpadding="5">
	<tr> <th>No  </th> <th>작성자  </th> <th>제목  </th> <th>내용  </th> <th>저장날짜  </th> <th>조회수  </th> <th>파일이름  </th> <th>파일크기  </th></tr>
	<tr> <td><%=b_id %></td> <td><%=b_name %></td> <td><%=b_title%></td> <td><%=b_content %></td> <td><%=b_date %></td> <td><%=b_view %></td> <td><%=b_filename %> </td><td><%=b_filesize %> </td></tr>
	</table> <br />
	<a href="modify.jsp?b_id=<%=b_id%>">정보 수정</a>  <a href="delete.jsp?b_id=<%=b_id%>">정보 삭제</a> <br /> <br />
<% 	 
	}
	pa2.close();
	pa1.close();
	pa.close();
}
catch(Exception e){
	out.println(e);
}
%>
<a href="stlist.jsp">게시글 리스트</a>
</body>
</html>