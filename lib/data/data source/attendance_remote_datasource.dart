import 'dart:io';

import 'package:attendance/core/utilities/create_pdf_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/employee.dart';
import '../models/employee_model.dart';

abstract class BaseRemoteDatasource {
  Stream<List<Employee>> getEmployeesData();

  Future<Employee> addNewEmployee(String name, String workingFrom,
      String workingTo, List<int> offDays, String allowedDelay);

  Future<String> addQrCodePdfToCloudAndGetLink(String id, String name, Size mq);

  Future<void> editEmployeeDetails(
    Employee employee,
    String newName,
    String workingFrom,
    String workingTo,
    List<int> offDays,
    List<DateTime> vacationDays,
    String allowedDelay,
  );

  Future<void> removeEmployeeAbsence(bool isApologyAccepted, Employee employee);
}

class RemoteDataSource extends BaseRemoteDatasource {
  @override
  Future<Employee> addNewEmployee(String name, String workingFrom,
      String workingTo, List<int> offDays, String allowedDelay) async {
    final fireStoreRef = FirebaseFirestore.instance.collection('employees');
    final json = {
      'name': name,
      'currentDayWorkingFrom': null,
      'currentDayWorkingTo': null,
      'workingFrom': workingFrom,
      'workingTo': workingTo,
      'absenceDays': 0,
      'employeeState': 'خارج ساعات العمل',
      'lateInMinutes': 0,
      'detailedReport': [],
      'employeeQrCodePdfLink': '',
      'id': '',
      'offDays': offDays,
      'allowedDelay': allowedDelay,
      'isTodayFirstDay': true,
      'outsideWorkingHours': true,
    };
    final String id = (await fireStoreRef.add(json)).id;
    json['id'] = id;
    await fireStoreRef.doc(id).update({'id': id});
    return EmployeeModel.fromJson(json);
  }

  @override
  Stream<List<Employee>> getEmployeesData() {
    final fireStoreRef =
        FirebaseFirestore.instance.collection('employees').orderBy('name');
    return fireStoreRef.snapshots().map(
      (event) {
        if (event.docs.isEmpty) {
          return [];
        }
        return event.docs.map((e) {
          return EmployeeModel.fromJson(
            e.data(),
          );
        }).toList();
      },
    );
  }

  @override
  Future<String> addQrCodePdfToCloudAndGetLink(
      String id, String name, Size mq) async {
    final pdf = await CreatePdfFile.run(name, id, mq);
    final Directory directory = await getApplicationDocumentsDirectory();
    final File pdfFile = await File('${directory.path}/$name.pdf').create();
    await pdfFile.writeAsBytes(pdf);
    final cloudStorageInstance = FirebaseStorage.instance;
    final rootRef =
        cloudStorageInstance.ref('/${name}_${id.substring(0, 3)}.pdf');
    final File qrPdf = File('${directory.path}/$name.pdf');
    await rootRef.putFile(qrPdf);
    final downloadUrl = await rootRef.getDownloadURL();
    final fireStoreInstance = FirebaseFirestore.instance;
    await fireStoreInstance.collection('employees').doc(id).update(
      {
        'employeeQrCodePdfLink': downloadUrl,
      },
    );
    await qrPdf.delete();
    return downloadUrl;
  }

  @override
  Future<void> editEmployeeDetails(
    Employee employee,
    String newName,
    String workingFrom,
    String workingTo,
    List<int> offDays,
    List<DateTime> vacationDays,
    String allowedDelay,
  ) async {
    final List<String> vacationDaysString =
        vacationDays.map((e) => e.toIso8601String()).toList();
    await FirebaseFirestore.instance
        .collection('employees')
        .doc(employee.id)
        .update(
      {
        'name': newName,
        'workingFrom': workingFrom,
        'workingTo': workingTo,
        'offDays': offDays,
        'vacationDays': vacationDaysString,
        'allowedDelay': allowedDelay,
      },
    );
  }

  @override
  Future<void> removeEmployeeAbsence(
      bool isApologyAccepted, Employee employee) async {
    await FirebaseFirestore.instance
        .collection('employees')
        .doc(employee.id)
        .update(
      {
        'isApologizing': false,
        'apologyMessage': null,
        'absenceDaysList': null,
        'absenceDays':
            isApologyAccepted ? employee.absenceDays - 1 : employee.absenceDays,
      },
    );
  }
}