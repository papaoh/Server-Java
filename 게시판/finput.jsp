<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파일 첨부 가능한 서버</title>
</head>
<body>
<h2>사내 정보 공유 시스템</h2>
<form action="fwrite_act.jsp" method="post" enctype="multipart/form-data" name="inputform">
<table  border="1" cellspacing="0" cellpadding="5">
<caption> 정보 공유 내용 작성 페이지</caption>
<tr> <th>작성자</th> <td><input type="text" name="b_name" value="" maxlength="30"></td></tr>
<tr> <th>이메일</th> <td><input type="text" name="b_mail" value="" maxlength="30"></td></tr>
<tr> <th>제목</th> <td><input type="text" name="b_title" value=""></td></tr>
<tr> <th>내용</th> <td><textarea name="b_content" rows="5" cols="50"></textarea></td></tr>
<tr> <th>비밀번호</th> <td><input type="password" name="b_pwd" value=""></td></tr>
<tr> <th width="200">첨부파일</th> <td><input type="file" name="b_filename" value=""></td></tr>
<tr> <td colspan="2" align="center"> <input type="submit" value="전송"> <input type="reset" value="취소"> </td> </tr>

</table>
</form>
<br />

<form action="fsearch.jsp" method="post" name="searchform">


<a href="flist.jsp">파일 리스트 페이지</a> <br />

<br />
검색내용을 확인하세요 <br />
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