import 'dart:convert';
import 'package:intl/intl.dart';

AppointmentListResponse appointmentListResponseFromJson(String str) => AppointmentListResponse.fromJson(json.decode(str));

String appointmentListResponseToJson(AppointmentListResponse data) => json.encode(data.toJson());

class AppointmentListResponse {
  AppointmentListResponse({
    this.response,
    this.appointments,
  });

  Response response;
  List<Appointment> appointments;

  factory AppointmentListResponse.fromJson(Map<String, dynamic> json) => AppointmentListResponse(
    response: Response.fromJson(json["response"]),
    appointments:json['appointments'] == null? null:  List<Appointment>.from(json["appointments"].map((x) => Appointment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "response": response.toJson(),
    "appointments": List<dynamic>.from(appointments.map((x) => x.toJson())),
  };
}

enum Status{
  OFFSET,
  ACCEPTED,
  REJECTED,
  PENDING,
  CANCELLED,
  CLOSE
}

enum ServiceAttr{
  PRICE,
  QTY,
}

class Appointment {
  static final DateFormat dateParser     = DateFormat("yyyy-MM-dd hh:mmaa");
  static final DateFormat dayDateMonthFormatter  = DateFormat("E MMM dd");
  static final DateFormat monthYearFormatter = DateFormat("MMMM yyyy");
  static final DateFormat dayFormatter  = DateFormat("E");
  static final DateFormat dateFormatter  = DateFormat("dd");
  static final DateFormat monthFormatter = DateFormat("MMM");
  static final DateFormat dateMonthYearFormatter = DateFormat("yyyy-MM-dd");
  static final DateFormat timeFormatter  = DateFormat().add_jm();

  Appointment({
    this.appointmentId,
    this.customerId,
    this.customerName,
    this.workerId,
    this.workerName,
    this.telephone,
    this.address,
    this.status,
    this.appointmentDate,
    this.appointmentTime,
    this.services,
    this.servicesId,
  });


  String appointmentId;
  String customerId;
  String customerName;
  String workerId;
  String workerName;
  String telephone;
  String address;
  Status status;
  DateTime appointmentDate;
  String appointmentTime;
  String services;
  List<int> servicesId;

  factory Appointment.fromJson(Map<String, dynamic> json){
    List<int> servicesId = [];
    
    if(json['services_id'] != null) {
      String servicesIdString = json['services_id'];
      List<String>serviceIdList = servicesIdString.split(',');
      for(String serviceId in serviceIdList) {
        servicesId.add(int.parse(serviceId));
      }
    }

    DateTime appointmentDateTime = dateParser.parse(
        json["appointment_date"].toString().toUpperCase());

    return Appointment(
      appointmentId: json["appointment_id"],
      customerId: json['customer_id'],
      customerName: json["customer_name"],
      workerId: json['worker_id'],
      workerName: json["worker_name"],
      telephone: json["telephone"],
      address: json["address"],
      status: Status.values[json["status_id"].toInt()],
      appointmentDate: appointmentDateTime,
      appointmentTime: timeFormatter.format(appointmentDateTime),
      services: json["services"],
      servicesId: servicesId,
    );
  }

    Map<String, dynamic> toJson() => {
      "appointment_id": appointmentId,
      "customer_id" : customerId,
      "customer_name": customerName,
      "worker_id":workerId,
      "worker_name": workerName,
      "telephone": telephone,
      "address": address,
      "status_id": status,
      "appointment_date": appointmentDate,
      "services": services,
    };

    String getAppointmentStatusName() => status.toString().split('.').last;


  String getAppointmentDateStringEMMMDD() => dayDateMonthFormatter.format(appointmentDate);
    String getAppointmentDateStringJM() => timeFormatter.format(appointmentDate);
    String getAppointmentDateStringE() => dayFormatter.format(appointmentDate);
    String getAppointmentDateStringDD() => dateFormatter.format(appointmentDate);
    String getAppointmentDateStringYYYYMMDD() => dateMonthYearFormatter.format(appointmentDate);
    String getAppointmentDateStringMMMYYYY() => monthYearFormatter.format(appointmentDate);
    String getAppointmentDateStringMMM() => monthFormatter.format(appointmentDate);
    static String convertAppointmentDateStringEMMMDD(DateTime appointmentDate) => dayDateMonthFormatter.format(appointmentDate);
    static String convertAppointmentDateStringJM(DateTime appointmentDate) => timeFormatter.format(appointmentDate);
    static String convertAppointmentDateStringDay(DateTime appointmentDate) => dayFormatter.format(appointmentDate);
    static String convertAppointmentDateStringDate(DateTime appointmentDate) => dateFormatter.format(appointmentDate);
    static String convertAppointmentDateStringDateMonthYear(DateTime appointmentDate) => dateMonthYearFormatter.format(appointmentDate);
    static String convertAppointmentDateStringMonthYear(DateTime appointmentDate) => monthYearFormatter.format(appointmentDate);
}

class Response {
  Response({
    this.status,
    this.msg,
  });

  int status;
  String msg;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    status: json["status"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
  };
}
