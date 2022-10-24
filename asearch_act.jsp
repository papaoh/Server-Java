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
<title>검색처리 페이지</title>
</head>
<body>
<%
// 예외처리문
try{
	// DB의 자료를 저장하기 위한 객체변수 선언
	int b_id, b_view;
	String b_name, b_title, b_content;  // 검색처리를 위한 객체 변수	
	String searchk = request.getParameter("search");    // 검색할 항목
	String keyword = request.getParameter("keyword");   // 검색할 키워드
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
		out.println("<br> 검색 결과:" + datacount + "개 </b> <br />");
		pa2.close();
	}
	int pagesize = 6;  // 검색이 된 데이터를 한페이지에 보여줄 갯수-1를 설정
	pagecount = datacount / pagesize; // 페이지의 갯수는 검색된 데이터 / 5
	if(datacount % pagesize > 0){  // 검색된 데이터가 5개가 넘어가면
		pagecount++; // 페이지가 다음페이지로 넘어가도록
	}
	//if((datacount % 5) == 0) pagecount = datacount/(pagesize)+1;  // 페이지 계산식
	else pagecount = datacount / pagesize +1;
	
	int mypage=1;  // 현재 페이지
	int abpage=1;  // 초기 페이지
	if(request.getParameter("mypage") != null){  // 만약 페이지가 변경이된다면
		mypage = Integer.parseInt(request.getParameter("mypage")); // 
		abpage = (mypage - 1) * pagesize;
		if(abpage <= 0) abpage =1; 
	}
	String sql ="select b_id, b_name, b_title, b_content, b_view from mboard where "+ searchk +" like '%" + keyword + "%' order by b_id desc";
	System.out.println(sql);
	ResultSet pa3 = pa1.executeQuery(sql);
	
	if(!pa3.next()){
		pagesize=0;
	}else{
		pa3.absolute(abpage);
	}
	%>
	<div> 검색 결과 입니다.</div>
	<table border="1" collspacing="0" cellpadding="5" width="55%">
	<tr> <th>ID</th> <th>이름</th> <th>제목</th> <th>내용</th> <th>조회수</th> </tr>
	<%
	for(int k=1; k<pagesize; k++){
		b_id = pa3.getInt(1);
		b_name = pa3.getString(2);
		b_title = pa3.getString(3);
		b_content = pa3.getString(4);
		b_view = pa3.getInt(5);
	
	%>
	<tr> <td><%=b_id%></td> <td><%=b_name%></td> <td><%=b_title%></td> <td><%=b_content%></td> <td><%=b_view%></td></tr>
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
   	for(int i=1; i<=pagecount; i++){  // 페이지 카운터만큼 반복하기
   		out.println("<a href=asearch_act.jsp?mypage=" + i + "&&search=" + searchk + "&&keyword=" + keyword + ">" + i + "  |</a>"); // 학생수만큼 출력해주기
   	}    // 페이지를 넘길때 옮긴 페이지 뿐만아니라 키워드와 검색항목도 같이 넘겨줘야됨. 하지만 이코드가 집에서는 정상적으로 작동을 하지만 학교컴퓨터로는 에러가나는 현상이 발생 
   	     // 인터넷을 찾아봐도 한글이 제대로 안들어가는 이유를 찾을 수 없다.
   }else{
   	out.println("1");
   }
   
}

catch(Exception e){
	out.println(e);
}


%>
<br />
<a href="stlist.jsp">정보 현황 목록 페이지</a>
</body>
</html>