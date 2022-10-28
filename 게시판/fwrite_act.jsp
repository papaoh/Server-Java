<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>  <!-- 파일을 서버에 저장하기 위한 라이브러리 선언 -->
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %> 
<%@ page import="java.util.*" %>
<% request.setCharacterEncoding("utf-8"); // post타입으로 전송받은 값을 utf-8 형식으로 받기 %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>데이터 처리 페이지</title>
</head>
<body>
<%
// 파일 처리 과정 - 파일이 저장되어지는 경로 설정   MIME타입 설정
ServletContext scontext = getServletContext();
String realForder = scontext.getRealPath("upload"); // 업로드된 파일의 위치에 해당하는 폴더 이름

try{   //예외처리문
	String b_filename="";
    String b_filesize="";
    MultipartRequest multi = new MultipartRequest(request, realForder, (1024*1024*5), "utf-8", new DefaultFileRenamePolicy());
    // 파일의 객체, 파일의 경로, 파일의 크기, 인코딩(한글이 들어올 경우 한글 깨지는 것을 방지), 동일한 이름의 파일을 들어오게되면 파일의 이름을 임의로 변경해주는 함수
    Enumeration<?> files = multi.getFileNames();  //확인 필요(과제)  람다형식으로 작동하는 법(Enumeration 람다형식)으로 검색하면 자료 나옴 정리 후 레포트로 제출하면될듯
    //Enumeration은 인터페이스로 	file
    String file1 = (String)files.nextElement();   //Enumeration의 메소드 nextElement()를 사용해 Enumeration에 저장된 요소를 반환해준다.
    String fileName1 = multi.getFilesystemName(file1);  // 파일의 이름을 저장
    
    if(fileName1 == null){  // 파일이 첨부되지 않았을 경우
    	b_filename = "default.png";
        b_filesize = "0Bytes";
    }  else{  // 반대로 파일이 첨부가 된다면
    	b_filename = fileName1;  // 파일의 이름 저장
        File file = multi.getFile("b_filename");  // 파일의 크기를 알기위한 multi문 선언
        b_filesize = ""+file.length()+"Bytes";  // 파일의 크기 저장
    }
    
    int b_id = 0;
    String b_name = multi.getParameter("b_name");
    String b_mail = multi.getParameter("b_mail");
    String b_title = multi.getParameter("b_title");
    String b_content = multi.getParameter("b_content");
    String b_pwd = multi.getParameter("b_pwd");
    
    // JDBC 드라이버 설정
	Class.forName("com.mysql.jdbc.Driver");
    // DB연동 (한글셋을 위해 Unicode와 utf8설정)
    Connection pa = DriverManager.getConnection("jdbc:mysql://localhost:3306/bbsboard?useUnicode=true&characterEncoding=utf8", "pen", "1234");
    // 쿼리문 처리
    Statement pa1 = pa.createStatement();
    ResultSet pa2 = pa1.executeQuery("select max(b_id) from mboard");
    if(pa2.next()){   // 저장되어 있는 데이터가 있는 경우
    	b_id = pa2.getInt(1);  // 저장되어있는 데이터의 값 저장
    	b_id = b_id + 1;   // 글을 하나 더 작성하기위해 + 1
    	pa2.close();  // 연결된 쿼리문 종료
    	pa1.close();
    }
    else{  // 저장되어 있는 데이터가 없는 경우
    	b_id = 1;  // 처음 작성하는 데이터는 1번부터 시작
    }
    
    PreparedStatement pa3 = pa.prepareStatement("insert into mboard(b_id, b_name, b_mail, b_title, b_content, b_date, b_view, b_pwd, b_filename, b_filesize) values(?,?,?,?,?,now(),0,?,?,?)");
    // 나머지값은 ?로 지정된 값이 아니지만 현재 시간과 조회수는 지정된 형식이 있기에 now()형식과 조회수는 0부터 시작이므로 0이 들어간다.
    pa3.setInt(1, b_id);            // id부터 filesize까지 전부 데이터 저장
    pa3.setString(2, b_name);
    pa3.setString(3, b_mail);
    pa3.setString(4, b_title);
    pa3.setString(5, b_content);
    pa3.setString(6, b_pwd);
    pa3.setString(7, b_filename);
    pa3.setString(8, b_filesize);
    
    pa3.executeUpdate();
    pa3.close();
    pa.close();
    
    response.sendRedirect("flist.jsp");
}
catch(Exception e){
	out.println(e);
}

%>
<br /> 
<h2> 입력 정보 저장 완료 되었습니다.</h2> <br />
<a href="finput.jsp">파일 입력 페이지</a>
</body>
</html>