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
<title>데이터 리스트 출력 페이지</title>
</head>
<body>
<div> 사내 정보 공유 내용 목록 현황</div>
<table border="1" cellspacing="0" cellpadding="5">
<tr align="center"> <th>번호</th> <th>사진</th> <th>제목</th> <th>작성자</th> <th>작성일자</th> <th>조회수</th></tr>
<%
try{
	String b_name;     // 데이터를 저장하기 위한 변수 선언
	String b_mail, mailtoyou;  //mailtoyou라는 타입이 따로 존재 사용하기 위해 변수 선언
	String b_title;
	String b_content;
	String b_date;
	String b_pwd;
	String b_filename;
	String b_filesize;
	int b_id;
	int b_view;
	int pagecount;           // 한 페이지에 나타낼 데이터의 갯수를 저장할 변수 선언
	int datacount = 0;       // 데이터의 갯수를 저장할 변수 선언
	
	
	//jdbc 드라이버 설정
	Class.forName("com.mysql.jdbc.Driver");
	// DB 연결
	Connection pa = DriverManager.getConnection("jdbc:mysql://localhost:3306/bbsboard?useUnicode=true&characterEncoding=utf8", "pen", "1234");
	// 쿼리문 처리
	Statement pa1 = pa.createStatement();
	ResultSet pa2 = pa1.executeQuery("select max(b_id) from mboard");  // 데이터의 갯수 알아내기
	if(pa2.next()){
		datacount = pa2.getInt(1);
		pa2.close();
	}
	// 목록에서 보여지는 데이터의 갯수 처리
	int pagesize = 5; // 한페이지에 들어갈 데이터의 갯수
	if((datacount % pagesize) == 0) pagecount = datacount/(pagesize);  // 페이지를 나눌때 나머지가 생기면 페이지를 하나 더 만드는 공식
	else pagecount = datacount / pagesize + 1;   
	int mypage = 1, abpage = 1;
	if(request.getParameter("mypage") != null){  // 만약 mypage데이터 값이 null이 아니면
		mypage=Integer.parseInt(request.getParameter("mypage"));  
		abpage = (mypage-1) * pagesize + 1;
		if(abpage <=0) abpage=1;
	}
	ResultSet pa3 = pa1.executeQuery("select b_id, b_name, b_mail, b_title, b_content, date_format(b_date, '%y-%m-%d'), b_view, b_pwd, b_filename, b_filesize from mboard order by b_id desc");
	if(!pa3.next()){
		pagesize = 0;
	} else{
		pa3.absolute(abpage);
	}
	for(int k=1; k<=pagesize; k++){   // 페이지사이즈(5)만큼 데이터 출력
		b_id = pa3.getInt(1);
		b_name = pa3.getString(2);
		b_mail = pa3.getString(3);
		b_title = pa3.getString(4);
		b_content = pa3.getString(5);
		b_date = pa3.getString(6);
		b_view = pa3.getInt(7);
		b_pwd = pa3.getString(8);
		b_filename = pa3.getString(9);  
		b_filesize = pa3.getString(10);
		if(!b_mail.equals("")){  // equals는 자바에서는 == 이랑 같은 뜻    만약 메일이 있다면
			mailtoyou="<a href=mailto:" +b_mail+">"+b_name+"</a>";  // 이름에다가 메일 주소 링크를 걸어주기
		} else{  // 없으면 그냥 이름만 넣어주고
			mailtoyou = b_name;
		}
		 %>
 <tr> <td align="center"><%=b_id%></td> <td><img src="upload/<%=b_filename%>" height="90"></td> <td><a href="fview.jsp?b_id=<%=b_id%>"><%=b_title%></a></td> <td><%=mailtoyou%></td> <td><%=b_date%></td> <td><%=b_view%></td></tr>		
		
<%	if(pa3.getRow() == datacount){
	     break;
    } else{
	     pa3.next();
    }
  }
	pa3.close();
	pa1.close();
	pa.close();
  
  %>
  </table>
  <% if(pagecount != 1){  // 페이지가 1개가 넘어간다면
  	for(int i=1; i<=pagecount; i++){  // 페이지 카운터만큼 반복하기
		out.println("<a href=flist.jsp?mypage=" + i + ">" + i + "  |</a>"); // 학생수만큼 출력해주기
	    }
    } else{
	    out.println("1");
    }
  }
catch(Exception e){
	out.println(e);
}
%>


<br />
<a href="finput.jsp">파일 입력 페이지</a>
<br /> <br />
검색내용을 확인하세요 <br />
<hr align="left" width="80%">
<form action="fsearch.jsp" method="post" name="searchform">
<select name="search">
<option>검색할 항목을 선택하세요</option>
<option value="b_name">작성자</option>
<option value="b_title">제목</option>
<option value="b_content">내용</option>
</select>
<input type="text" name="keyword">
<input type="submit" value="검색"> 
</form>

</body>
</html>