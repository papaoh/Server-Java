<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파일 첨부 가능한 서버 페이지</title>
</head>
<body>
<h2>사내 정보 공유 시스템</h2>
<form action="write_act.jsp" method="post" name="insert" enctype="multipart/form-data">
<table border="1" cellspacing="0" cellpadding="5"> 
<caption> 정보 공유 내용 작성 페이지 </caption>
<tr><td> 작성자  </td>  <td width="150"> <input maxlength="30" type="text" name="b_name" value=""></td></tr>
<tr><td> 이메일  </td>   <td><input type="text" name="b_mail" value=""></td></tr>
<tr><td> 제목  </td>   <td><input type="text" name="b_title" value=""></td></tr>
<tr><td> 내용  </td>   <td><textarea rows="5" cols="50" name="b_content"></textarea></td></tr>
<tr><td> 비밀번호  </td>  <td><input type="password" name="b_pwd" value=""></td></tr>
<tr><td> 첨부파일(사진) </td>   <td><input type="file" name="b_filename"> </td>	</tr>
<tr> <td colspan="2" align="center"><input type="submit" value="저장"> <input type="reset" value="취소"></td></tr>


</table>
</form>
<br />
<form action="">
<select>
<option> 검색할 항목을 선택하세요</option>
<option value="b_name"> 작성자 </option>
<option value="b_title"> 제목 </option>
</select>
<input type="text" name="keyword">
<input type="button" value="검색">
</form>


<a href="stlist.jsp">학생 정보 목록 페이지</a>

</body>
</html>