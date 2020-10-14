import 'dart:convert';
import 'dart:developer';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Utility/RestApi/change_password_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/customer_detail_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/edit_info_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/logout_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/user_get_customer_credit_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/user_top_up_customer_credit_ response.dart';
import 'package:gps_tracking_system/Model/end_user.dart';
import 'package:gps_tracking_system/Model/user.dart';
import 'package:gps_tracking_system/Utility/RestApi/appointment_list_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/admin_add_worker_response';
import 'package:gps_tracking_system/Utility/RestApi/admin_login_response.dart' as AdminLogin;
import 'package:gps_tracking_system/Utility/RestApi/user_login_response.dart' as CustomerLogin;
import 'package:gps_tracking_system/Utility/RestApi/user_sign_up_response.dart';
import 'package:gps_tracking_system/Utility/url_encoder.dart';
import 'package:gps_tracking_system/Response/user_group.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

const tempDomainName = "http://192.168.68.107/";//"http://10.0.2.2/";

class RestApi
{
  RestApi._();
  
  static _Admin admin = _Admin();
  static _Customer customer = _Customer();
  static const String _GOOGLE_MAP_API_KEY = "AIzaSyBrNE3BrIA9VwrjmlsHo25fVdchca9H04g";

  static Future<Map<String, dynamic>> getRouteTimeDistance(List<LatLng> routeCoordinate) async {
    String url = "https://api.mapbox.com/directions-matrix/v1/mapbox/driving-traffic/";
    String accessToken = "?annotations=duration,distance&access_token=pk.eyJ1IjoiamVmZnJleXRhbiIsImEiOiJja2V2ZGx2NXMwOWRnMzFwOXAxeWJ4OHliIn0.qdcdB0cFAtgG3rvmHAXOGw";

    for(int i = 0 ; i < routeCoordinate.length; i++){
      url += routeCoordinate[i].longitude.toString();
      url += ",";
      url += routeCoordinate[i].latitude.toString();
      url += ";";
    }

    url = url.substring(0, url.length - 1);
    url += accessToken;
    log("Calling MapBox distance API : " + url);
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> addressToCoordinate(String address) async{
    address = URLEncoder.encodeURLParameter(address);
    String url = "https://maps.googleapis.com/maps/api/place/textsearch/json?query="+address+"&key=" + _GOOGLE_MAP_API_KEY;
    log("Calling google map API : " + url);
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> latLngToAddress(LatLng position) async{
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng="+position.toString()+"&key=" + _GOOGLE_MAP_API_KEY;
    log("Calling google map API : " + url);
    var response = await http.get(url);
    return jsonDecode(response.body);
  }
}

class _Admin {

  static const String _DOMAIN_NAME = tempDomainName + "admin/";

  Future<AdminLogin.LoginResponse> login(String username, String password) async {
    String url = _DOMAIN_NAME + "index.php?route=api/login";
    log("Calling login API : " + url);

    var response = await http.post(url, body: {
      "username": username,
      "password": password
    });

    return AdminLogin.loginResponseFromJson(response.body);
  }

  Future<AddWorkerResponse> addWorker(String username,
      String userGroup,
      String firstName,
      String lastName,
      String email,
      String imagePath,
      String password,
      String status,
      String confirm) async {
    String url = _DOMAIN_NAME + "index.php?route=api/user/add&api_key=" +
        User.getToken();
    log("Calling add user API : " + url);

    var request = http.MultipartRequest("POST", Uri.parse(url));
    //add text fields
    request.fields["username"] = username;
    request.fields["user_group_id"] = userGroup;
    request.fields["firstname"] = firstName;
    request.fields["lastname"] = lastName;
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["status"] = status;
    request.fields["confirm"] = confirm;

    //create multipart using filepath, string or bytes
    if (imagePath.isNotEmpty)
      request.files.add(await http.MultipartFile.fromPath("file", imagePath,
          contentType: MediaType(
              "image", p.extension(imagePath).substring(1))));

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    log(String.fromCharCodes(responseData));
    return addWorkerResponseFromJson(String.fromCharCodes(responseData));
  }

  Future<UserGroupResponse> getUserGroup() async {
    String url = _DOMAIN_NAME +
        "index.php?route=api/user_group/getUserGroup&api_key=" +
        User.getToken();
    log("Calling getUserGroup API : " + url);

    var response = await http.post(url, body: {});
    return userGroupResponseFromJson(response.body);
  }

  Future<AppointmentListResponse> getAppointmentList() async{
    String url = _DOMAIN_NAME;
    if(User.getRole() == Role.OWNER) {
      url += "index.php?route=api/appointment/getAllAppointments&api_key=" +
          User.getToken();
      log("Calling get appointment list (Owner)  API : " + url);
    } else {
      url += "index.php?route=api/appointment/getWorkerAppointments&api_key=" +
          User.getToken();
      log("Calling get appointment list (Worker)  API : " + url);
    }

    var response = await http.post(url, body: {});
    return appointmentListResponseFromJson(response.body);
  }


}

class _Customer{
  static const String _DOMAIN_NAME = tempDomainName; //android emulator 10.0.2.2

  Future<CustomerLogin.LoginResponse> login(String email, String password) async {
    String url = _DOMAIN_NAME + "index.php?route=api/login";
    log("Calling login API : " + url);

    var response = await http.post(url, body: {
      "email": email,
      "password": password
    });
    return CustomerLogin.loginResponseFromJson(response.body);
  }

  Future<SignUpResponse>signUp(EndUser endUser) async{
    String url = _DOMAIN_NAME + "index.php?route=api/register";
    log("Calling sign up API : " + url);

    var response = await http.post(url, body: {
      "email": endUser.email,
      "firstname": endUser.firstName,
      "lastname": endUser.lastName,
      "password": endUser.password,
      "telephone": endUser.contactNo,
      "confirm":endUser.confirm
    });

    log(response.body);
    return signUpResponseFromJson(response.body);
  }
  
   Future<TopUpResponse> topUpCustomerCredit(double credit) async{
    String url= _DOMAIN_NAME + "index.php?route=api/credit/topUpCustomerCredit&api_key="+User.getToken();
    log("Calling top up customer credit API : " + url);

    var response = await http.post(url,body: {
      "credit":credit.toString(),
      "description": "Top up credit"
    });
    log(response.body);
    return topUpResponseFromJson(response.body);
  }

  Future<CustomerCreditResponse> getCustomerCredit() async{
    String url= _DOMAIN_NAME + "index.php?route=api/credit/getCustomerCredit&api_key="+User.getToken();
    log("Calling get customer credit API : " + url);
    var response = await http.get(url);
    return customerCreditResponseFromJson(response.body);
  }

  Future<CustomerDetailResponse> getCustomerDetail() async{
    String url= _DOMAIN_NAME + "index.php?route=api/customer/getCustomerDetail&api_key="+User.getToken();
    log("Calling get customer detail API : " + url);
    var response = await http.get(url);
    return customerDetailResponseFromJson(response.body);
  }

  Future<LogoutResponse> logout() async{
    String url= _DOMAIN_NAME + "index.php?route=api/customer/logout&api_key="+User.getToken();
    log("Calling logout API : " + url);
    var response = await http.get(url);
    return logoutResponseFromJson(response.body);
  }

  Future<EditInfoResponse>editInfo(String firstName,String lastName,String telephone,String email) async{
    String url = _DOMAIN_NAME + "index.php?route=api/customer/editInformation&api_key="+User.getToken();
    log("Calling edit information API : " + url);

    var response = await http.post(url, body: {
      "email": email,
      "firstname": firstName,
      "lastname": lastName,
      "telephone":telephone,
    });

    return editInfoResponseFromJson(response.body);
  }

  Future<ChangePasswordResponse>changePassword(String oldPassword,String newPassword,String confirmPassword) async{
    String url = _DOMAIN_NAME + "index.php?route=api/customer/changePassword&api_key="+User.getToken();
    log("Calling change password API : " + url);

    var response = await http.post(url, body: {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
      "confirm": confirmPassword,
    });

    log(response.body);
    return changePasswordResponseFromJson(response.body);
  }
}

