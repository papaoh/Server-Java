<%@page import="java.sql.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.Enumeration" %><!-- 3줄 모두 아까 WEB-INF/lib 파일에 넣어줬던 API 파일 타입 변환 명령을 사용하기 위한 page설정 -->
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="java.awt.Image" %>   <!-- 서버에 저장된 이미지 크기를 알아내려할때 선언해준다. -->
<%@ page import="javax.swing.ImageIcon" %>
<% request.setCharacterEncoding("utf-8");%> <!-- DB에서 들어오는 데이터는 utf-8 형식으로 받겠다. --> 
<!DOCTYPE html >
<html>
<head>
<meta charset="UTF-8">
<title>DB저장 페이지</title>
</head>
<body>
<h3>정보 입력 처리 완료</h3>
<% 
	String uploadPath = request.getRealPath("/upload");   // 실제 서버 시스템 상의 파일이 저장되는 경로를 설정한다 (받아오는 파일을 upload파일에 저장)
	int size = 10*1024*1024; // 업로드 파일의 최대 크기 설정
	String b_filename="";
   //client가 server에게 요청한 정보(stinfo.jsp파일에서 날라오는 학생정보)를 처리할 경우 두가지로 결과가 처리된다 Success or Fail
   try{
	   MultipartRequest multi = new MultipartRequest(request, uploadPath, size, "utf-8", new DefaultFileRenamePolicy());  
	   // 파일을 업로드하기위함 경로,크기,형식 지정 
	   // 이 명령을 실행하는 순간 파일 업로드 실행
	   
	   int b_id = 0;
	   String b_name = multi.getParameter("b_name");  // 작성자를 저장하기위한 변수 선언
	   String b_title = multi.getParameter("b_title");  // 제목을 저장하기위한 변수 선언
	   String b_mail = multi.getParameter("b_mail");    // 이메일을 저장하기위한 변수 선언
	   String b_content = multi.getParameter("b_content");  // 내용를 저장하기위한 변수 선언
	   String b_date = "1";  // 작성일자를 저장하기위한 변수 선언
	   int b_view = 0;  // 조회수르 저장하기위한 변수 선언
	   String b_pwd = multi.getParameter("b_pwd");  // 비밀번호를 저장하기위한 변수 선언
	   
	   
	   Enumeration files = multi.getFileNames();   // 업로드된 파일들의 이름을 반환한다.
       String file1 = (String)files.nextElement(); 
       b_filename = multi.getFilesystemName(file1);
      
       String filename = uploadPath + "/" + b_filename;  // 이미지 파일 위치
       Image img = new ImageIcon(filename).getImage();  // 이미지 가져오기
       int imgWidth = img.getWidth(null);		//가로 사이즈
       int imgHeight = img.getHeight(null);		//세로 사이즈
       String b_filesize = Integer.toString(imgWidth) + "*" + Integer.toString(imgHeight);   // 이미지 크기
	   
	   // DB 연동하기 위한 드라이버 설정
	   Class.forName("com.mysql.jdbc.Driver");
	   Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bbsboard?useUnicode=true&characterEncoding=utf8", "pen", "1234");
	   
	   Statement stmt = conn.createStatement();
	   ResultSet rs = stmt.executeQuery("select max(b_id) from mboard");  // mboard 테이블의 게시글 갯수 알아내는 쿼리문
	   if(rs.next()){   // 게시글 ID는 자동으로 1씩증가
		   b_id = rs.getInt(1);
		   b_id = b_id + 1;
		   rs.close();
		   stmt.close();
	   }
	   else{  // 만약 처음 데이터를 넣는거라면
		   b_id = 1;
	   }
	   PreparedStatement pstmt = conn.prepareStatement("insert into mboard(b_id, b_name, b_title, b_mail, b_content, b_date, b_view, b_pwd, b_filename, b_filesize) values(?,?,?,?,?,now(),?,?,?,?)");
	   pstmt.setInt(1, b_id);         // DB에 ID 추가
	   pstmt.setString(2, b_name);    // DB에 작성자 추가
	   pstmt.setString(3, b_title);    // DB에 제목 추가
	   pstmt.setString(4, b_mail);     // DB에 이메일 추가
	   pstmt.setString(5, b_content);  // DB에 내용 추가
	   pstmt.setInt(6, b_view);        // DB에 조회수 추가
	   pstmt.setString(7, b_pwd);      // DB에 패스워드 추가
	   pstmt.setString(8, b_filename);   // DB에 파일이름 추가
	   pstmt.setString(9, b_filesize);   // DB에 파일크기 추가
	   
	   pstmt.executeUpdate();
	   conn.close();
	   
	   response.sendRedirect("stlist.jsp");
   }
   catch(Exception e){
	   out.print(e);  // 생기는 에러 출력
   }
 
%>

</body>
</html>