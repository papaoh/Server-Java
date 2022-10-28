<%@page import="java.util.Set"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% request.setCharacterEncoding("utf-8"); %>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상세정보 보기 페이지</title>
</head>
<body>
<%
try{
	int b_id, b_view;    // 클릭한 게시글에 해당하는 정보(데이터)를 저장하기위한 변수 선언 b_id ~ b_filesize까지
	String b_name;
	String b_mail, mailtoyou;
	String b_title;
	String b_content;
	String b_date;
	String b_pwd;
	String b_filename;
	String b_filesize;
	String id = request.getParameter("b_id");  // id는 데이터를 넘겨주면서 문자열로 변환됨
	b_id = Integer.parseInt(id);  // 글 번화는 정수형 변환
	
	// JDBC 드라이버 설정
	Class.forName("com.mysql.jdbc.Driver");
	// DB 연동
	Connection pa = DriverManager.getConnection("jdbc:mysql://localhost:3306/bbsboard?useUnicode=true&characterEncoding=utf8", "pen", "1234");
	// SQL 설정
	Statement pa1 = pa.createStatement();  // date_format 형식(확인하기) %y:2자리 년도, %c:숫자월(한자리는 한자리로), %e:일(자리수), %H:시간, %i:분, %s:초
	String sql = "select b_id, b_name, b_mail, b_title, b_content, date_format(b_date,'%y-%c-%e-%H-%i-%s'), b_view, b_pwd, b_filename, b_filesize from mboard where b_id=" + id;
	ResultSet pa2 = pa1.executeQuery(sql); // 문자열로 변환해서 SQL 명령 실행
	if(pa2.next()){
		b_id = pa2.getInt(1);    // 1부터~10까지 해당하는 b_id의 데이터를 DB에서 받아와서 변수에 저장(날씨 같은경우 특별히 지정하여 저장)
		b_name = pa2.getString(2);
		b_mail = pa2.getString(3);
		b_title = pa2.getString(4);
		b_content = pa2.getString(5);
		b_date = pa2.getString(6);
		b_view = pa2.getInt(7);
		b_pwd = pa2.getString(8);
		b_filename = pa2.getString(9);
		b_filesize = pa2.getString(10);
		
		if(!b_mail.equals("")){  // 만약 메일의 주소가 있다면
			mailtoyou = "<a href=mailto:" + b_mail + ">" + b_name + "</a>";  // mailto라는 형식이 존재,  클릭시 바로 이메일로 이동
		} else{
			mailtoyou="";  // 없으면 빈공간으로 저장
		}
		%>
		<div>
		<table border="1" callspacin="0" callpadding="5">
		<tr><th>번호</th> <th>이미지(사진)</th> <th>제목</th> <th>작성자</th> <th>이메일</th> <th>작성일자</th> <th>조회수</th> <th>내용</th> </tr>
		<tr><td><%=b_id%></td> <td><img src="upload/<%=b_filename%>" height="100"><br /><%=b_filesize%></td>  <td><%=b_title%></td> <td><%=b_name%></td> <td><%=mailtoyou%></td> <td><%=b_date%></td> <td><%=b_view%></td> <td><%=b_content%></td> </tr>
		</table>
		<pre> <!-- 작성한 문단 그대로 띄워쓰기, 줄바뀜 출력 -->
		<a href="modify.jsp?b_id=<%=b_id%>">공유 정보 수정</a> | <a href="delete_act.jsp?b_id=<%=b_id%>">공유 정보 삭제</a> 
		</pre>
		<br /><br /><br />
		<a href="flist.jsp">정보 공유 목록 페이지</a>
		</div>
		<% 
	}
	pa2.close();
	pa1.executeUpdate("update mboard set b_view=b_view+1 where b_id=" + id);  // 조회수 증가 쿼리문
	pa1.close();
	pa.close();
}
catch(Exception e){
	out.println(e);
}
%>

</body>
</html>
