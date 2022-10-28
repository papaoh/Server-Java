<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import ="java.io.*" %>
<%@ page import ="java.util.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<% String b_name = null;  // DB의 이름을 저장하기위한 변수 선언(초기화를 안해주면 아래 input value에서 에러남)
   String b_title = null;  // DB의 제목을 저장하기위한 변수 선언
   String b_mail = null; // DB의 이메일을 저장하기위한 변수 선언
   String b_content = null; // DB의 내용을 저장하기위한 변수 선언
   String b_pwd = null;     // DB의 비밀번호를 저장하기위한 변수 선언
   int b_id = Integer.parseInt(request.getParameter("b_id")); // 번호저장은 String 타입으로 Int형으로 형변환
   // out.println("수정 게시글 번호:" + b_id + "<br />");
   
   // JDBC 드라이버 설정
   Class.forName("com.mysql.jdbc.Driver");
   // DB 연동
   Connection pa = DriverManager.getConnection("jdbc:mysql://localhost:3306/bbsboard?useUnicode=true&characterEncoding=utf8", "pen", "1234");
   
   // SQL query문
   Statement pa1 = pa.createStatement();
   ResultSet pa2 = pa1.executeQuery("select b_name, b_title, b_mail, b_content, b_pwd from mboard where b_id="+b_id);
   if(pa2.next()){   
   	b_name = pa2.getString(1);   // 작성자
   	b_title = pa2.getString(2);  // 제목
   	b_mail = pa2.getString(3);   // 이메일
   	b_content = pa2.getString(4);  // 내용
   	b_pwd = pa2.getString(5);    // 비밀번호
   }
   pa2.close();  //  
   pa1.close();  // 쿼리문 실행 종료
   pa.close();   // DB연동 종료
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수정 페이지</title>
</head>
<body>
<form action="modify_act.jsp" method="post" name="myform">
<input type="hidden" name="b_id" value="<%=b_id%>">
<table border="1" collspacing="1" collpadding="5" width="40%">
<tr> <th>이름</th>   <td><input type="text" name="b_name" value="<%=b_name%>" size=52></td> </tr>
<tr> <th>제목</th>   <td><input type="text" name="b_title" value="<%=b_title%>" size=52></td> </tr>
<tr> <th>이메일</th>   <td><input type="text" name="b_mail" value="<%=b_mail%>" size=52></td> </tr>
<tr> <th>내용</th>   <td><input type="text" name="b_content" value="<%=b_content%>" size=52></td> </tr>
<tr> <th>비밀번호</th>   <td><input type="password" name="b_pwd" value="<%=b_pwd%>" size=52></td> </tr>
<tr> <td colspan="2" align="center"> <input type="submit" value="수정 저장"> <input type="reset" value="수정 취소"></td></tr>

</table>
</form>
<br />
<a href="flist.jsp">정보 목록 페이지</a> | <a href="finput.jsp">정보 입력 페이지</a>
</body>
</html>
