<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>검색 처리 페이지</title>
</head>
<body>
<%
// 예외처리문
try{
	// DB의 자료를 저장하기 위한 객체변수 선언
	int b_id, b_view;
	String b_name, b_mail, b_title, b_content, b_filename, b_filesize, b_date, mailtoyou;  // 검색처리를 위한 객체 변수	
	String searchk = request.getParameter("search");    // 검색할 항목
	String keyword = request.getParameter("keyword");   // 검색할 키워드

	// out.println(searchk);  // 검색하려는 목록이 제대로 출력이 되는지 확인
	// out.println(keyword);  // 입력한 데이터가 제대로 출력이 되는지 확인
	int datacount = 0; // 데이터 목록처리 저장을 위한 변수
	int pagecount; // page 계산 처리를 위한 변수
	// JDBC 드라이버 설정
	Class.forName("com.mysql.jdbc.Driver");
	
	Connection pa = DriverManager.getConnection("jdbc:mysql://localhost:3306/bbsboard?useUnicode=true&characterEncoding=utf8", "pen", "1234");
	Statement pa1 = pa.createStatement();
	// 쿼리문을 사용해 키워드를 가진 학생수를 체크하여 페이지를 나눌지 결정
	ResultSet pa2 = pa1.executeQuery("select count(b_id) from mboard where " + searchk + " like '%" + keyword + "%'");
	
	if(pa2.next()){
		datacount = pa2.getInt(1);
		pa2.close();
	}
	int pagesize = 5; // 한페이지에 들어갈 데이터의 갯수
	if((datacount % pagesize) == 0) pagecount = datacount/(pagesize);  // 페이지를 나눌때 나머지가 생기면 페이지를 하나 더 만드는 공식
	else pagecount = datacount / pagesize + 1;   
	int mypage = 1, abpage = 1;
	if(request.getParameter("mypage") != null){  // 만약 mypage데이터 값이 null이 아니면
		mypage=Integer.parseInt(request.getParameter("mypage"));  
		abpage = (mypage-1) * pagesize + 1;
		if(abpage <=0) abpage=1;
	}
	String sql ="select b_id, b_name, b_mail, b_title, b_content, b_view, b_filename, b_filesize, date_format(b_date, '%y-%m-%d') from mboard where "+ searchk +" like '%" + keyword + "%' order by b_id desc";
	// System.out.println(sql);  // sql문 출력이 제대로 나오는지 콘솔창으로 확인
	ResultSet pa3 = pa1.executeQuery(sql);
	
	if(!pa3.next()){  // 데이터가 없다면
		pagesize=0;    // 페이지는 0으로 처리
	}else{  // 데이터가 있다면
		pa3.absolute(abpage);  // 해당하는 데이터 출력
	}
	%>
	<div> 검색 결과는 <font color="red" face="바탕"> <%=datacount%> </font>개 입니다.</div>
	<table border="1" cellspacing="0" cellpadding="5" width="55%">
	<tr> <th>번호</th> <th>사진</th> <th>제목</th> <th>작성자</th> <th>작성일자</th> <th>조회수</th> </tr>
	<%
	for(int k=1; k<=pagesize; k++){  // 검색한 조건에맟는 번호,작성자,메일,제목,내용,조회수,파일이름,파일크기,작성일자를 변수에 저장
		b_id = pa3.getInt(1);
		b_name = pa3.getString(2);
		b_mail = pa3.getString(3);
		b_title = pa3.getString(4);
		b_content = pa3.getString(5);
		b_view = pa3.getInt(6);
		b_filename = pa3.getString(7);
		b_filesize = pa3.getString(8);
		b_date = pa3.getString(9);
		if(!b_mail.equals("")){  // equals는 자바에서는 == 이랑 같은 뜻    만약 메일이 있다면
			mailtoyou="<a href=mailto:" +b_mail+">"+b_name+"</a>";  // 이름에다가 메일 주소 링크를 걸어주기
		} else{  // 없으면 그냥 이름만 넣어주고
			mailtoyou = b_name;
		}
	%>
	<tr> <td><%=b_id%></td> <td><img src="upload/<%=b_filename%>" height="90"><br /><%=b_filesize%></td> <td><a href="fview.jsp?b_id=<%=b_id%>"><%=b_title%></a></td> <td><%=mailtoyou%></td> <td><%=b_date%></td> <td><%=b_view%></td></tr>
	<% 
	  if(pa3.getRow() == datacount){
		  break;
	  }else{
		  pa3.next();
	  }
	}
	%>
	</table>
<%	
   pa3.close();
   pa1.close();
   pa.close();
   if(pagecount != 1){  // 페이지가 1개가 넘어간다면
   	for(int i=1; i<=pagecount; i++){  // 페이지 카운터만큼 반복하기(페이지에 링크를 걸어주면서 검색어, 항목, 현재페이지 넘겨주기)
   		out.println("<a href=fsearch.jsp?mypage=" + i + "&&search=" + searchk + "&&keyword=" + keyword + ">" + i + "  |</a>"); // 학생수만큼 출력해주기
   	}  
   }else{ // 페이지가 하나라면
   	out.println("1");
   }
   
}

catch(Exception e){  // 예외처리문
	out.println(e);
}


%>
<br />
<a href="flist.jsp">파일 리스트 페이지</a>
</body>
</html>