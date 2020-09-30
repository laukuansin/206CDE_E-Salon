import 'package:gps_tracking_system/Model/end_user.dart';
import 'package:gps_tracking_system/Model/service.dart';
import 'package:gps_tracking_system/Model/worker.dart';
import 'package:gps_tracking_system/Model/customer.dart';

class Appointment{
  final EndUser customer;
  final EndUser worker;
  DateTime date;
  String address;
  Map<Service, int> service;

  Appointment(Customer customer, Worker worker):
      customer  = customer,
      worker    = worker;

}