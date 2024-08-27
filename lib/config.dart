import 'dart:io';

final url =  Platform.isAndroid ? 'http://192.168.1.22:3000' : 'http://localhost:3000';
final login = url + "/api/login";
final register = url +"/api/register" ;
final verification = url + "/api/checkCode";
final createAccount = url + "/api/createAccount";
final forgot_pass = url + "/api/forgotPass";
final resetPassAPI = url + "/api/resetPass";
final editProfile = url + "/api/editProfile";


//DATE
final checkDate = url + "/api/checkDate";
final getDate = url + "/api/getDate";
final getMonth = url + "/api/getMonth";
final checkDateNotice = url + "/api/checkDateNotice";
final chartList = url + "/api/chart";

//Diary
final changeFavorite = url + "/api/changeFavorite";
final detailDiary = url + "/api/detailDiary";
final editDiaryy = url + "/api/editDiary";
final deleteDiaryy = url + "/api/deleteDiary";
final addDiaryy = url + "/api/addDiary";
final getListFavorite = url + "/api/getListFvr";


//Notice
final checkNoticeMemori = url + "/api/checkNoticeMemori";
final checkNoticeAddress = url + "/api/noticeAddress";
final checkNoticeHPBD = url + "/api/checkNoticeBirthday";
final getListNotice = url + "/api/getListNotice";
final getListMemory = url + "/api/getistMemory";
final getListAddress = url + "/api/getistAddress";