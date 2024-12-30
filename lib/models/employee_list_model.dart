// To parse this JSON data, do
//
//     final employeeListModel = employeeListModelFromJson(jsonString);

import 'dart:convert';

EmployeeListModel employeeListModelFromJson(String str) => EmployeeListModel.fromJson(json.decode(str));

String employeeListModelToJson(EmployeeListModel data) => json.encode(data.toJson());

class EmployeeListModel {
  String status;
  List<Employee> employee;

  EmployeeListModel({
    required this.status,
    required this.employee,
  });

  factory EmployeeListModel.fromJson(Map<String, dynamic> json) => EmployeeListModel(
    status: json["status"],
    employee: List<Employee>.from(json["employee"].map((x) => Employee.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "employee": List<dynamic>.from(employee.map((x) => x.toJson())),
  };
}

class Employee {
  String repId;
  String repName;

  Employee({
    required this.repId,
    required this.repName,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    repId: json["rep_id"],
    repName: json["rep_name"],
  );

  Map<String, dynamic> toJson() => {
    "rep_id": repId,
    "rep_name": repName,
  };
}
