<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출력 페이지</title>
</head>
<body>
<table border="1" cellspacing="0" cellpadding="5">
<caption>게시글 정보 공유</caption>
<tr><th> ID </th> <th> 작성자 </th> <th> 제목 </th> <th> 저장일자 </th> <th> 조회수 </th> </tr>
<% 
try{
	//DB 데이터를 저장할 변수 선언
	int b_id;
	int datacount = 0;  // 데이터 갯수를 저장할 변수 선언
	int pagecount; // 페이지를 계산을 해줄 변수선언
	String b_name, b_title, b_date, b_view;
	// 데이터 베이스 드라이버 설정
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bbsboard?useUnicode=true&characterEncoding=utf8", "pen", "1234");
	
	// Query 문을 실행하기위한 설정
	Statement stmt = conn.createStatement();
	
	ResultSet rs0 = stmt.executeQuery("select count(b_id) from mboard");  //학생 수 알아내기
	if(rs0.next()){  
		datacount = rs0.getInt(1);  // datacount에 학생수 저장
		rs0.close();  // 쿼리문 닫기
	}
	int pagesize = 6;  // 한페이지에 보여줄 학생 수 -1
	/* pagecount = datacount / pagesize;
	if((datacount % pagesize) > 0) pagecount++;  // 페이지 계산식 */
	if((datacount % pagesize == 0)) pagecount = datacount/(pagesize+1) + 1;
	else pagecount = datacount / pagesize + 1;
	
	int mypage = 1; // 페이지의 기본값 설정
	int abpage = 1; // 현재 보여지는 페이지 기본값
	/* 한 페이지에 보여주는 학생 목록 수에 따라 페이지 수를 계산*/
	if(request.getParameter("mypage")!=null){  // 만약 페이지가 null값이 아니면(학생이 있다면)
		mypage = Integer.parseInt(request.getParameter("mypage")); // 사용자가 클릭한  페이지의 값 불러오기
		abpage = (mypage - 1)*pagesize+1;   
		if(abpage <= 0) abpage=1;
	}
	
	ResultSet rs = stmt.executeQuery("select b_id, b_name, b_title, b_date, b_view from mboard order by b_id desc");
	if(!rs.next()){  // 만약 학생이 없다면
		pagesize = 0;  // 페이지 사이즈는 0으로 처리
	}
	else{
		rs.absolute(abpage);  
	}
	for(int k=1; k<=pagesize; k++){  // 지정한 한페이지에 보여줄 데이터 저장하기
		b_id = rs.getInt(1);   // ID
		b_name = rs.getString(2);  // 작성자
		b_title = rs.getString(3);  // 제목
		b_date = rs.getString(4);   // 작성시간
		b_view = rs.getString(5);   // 조회수
	
	/* 
	while(rs.next()){
		id = rs.getInt(1);
		name = rs.getString(2);
		dept = rs.getString(3);
		address = rs.getString(4);
		birthym = rs.getString(5);  */
	
	
%>

<tr><td><%=b_id%></td> <td><a href="view.jsp?b_id=<%=b_id%>"><%=b_name%></a></td> <td><%=b_title%></td>  <td><%=b_date%></td> <td><%=b_view%></td> </tr>
<%
    if(rs.getRow() == datacount){  // 만약 다음페이지로 넘어갈 데이터가 남지 않는다면
    	break;  // 종료
    }else{  // 그게아니고 아직 데이터가 남아서 계속 출력을 해야된다면
    	rs.next();   // 다음 페이지에 계속해서 출력하기
    }
	}
    rs.close();
    rs0.close();
    stmt.close();
    conn.close();
    
%>  </table>
<%	
    if(pagecount != 1){  // 페이지가 1개가 넘어간다면
    	for(int i=1; i<=pagecount; i++){  // 페이지 카운터만큼 반복하기
    		out.println("<a href=stlist.jsp?mypage=" + i + ">" + i + "  |</a>"); // 학생수만큼 출력해주기
    	}
    }else{
    	out.println("1");
    }

	
    }
 catch(Exception e){ 
   	out.println(e);
 }
%>

<br />
<a href="stinfo.jsp">정보 입력 페이지</a>
<br />
<div>
<form action="asearch_act.jsp" method="post">
<select name="search" class="search">  <!-- 검색 항목 -->
<option> 검색 목록을 선택하시오 </option>
<option value="b_title"> 제목 </option> 
<option value="b_name"> 이름 </option>
</select> <!-- 검색 항목 끝 -->
<input type="text" name="keyword" value=""> <!-- 검색 단어 -->
<input type="submit" value="검색"> 

</form>
</div>

</body>
</html>