import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../../domain/entities/employee.dart';
import '../../domain/use cases/upload_excel_file_to_storage.dart';
import '../utilities/dependency_injection.dart';

class ExcelProvider extends ChangeNotifier {
  bool loading = false;

  Future<String> saveExcelFile(Employee employee) async {
    loading = true;
    notifyListeners();
    final workbook = Workbook();
    final sheet = workbook.worksheets[0];
    sheet.isRightToLeft = true;
    final List<ExcelDataRow> excelDataRows = employee.detailedReport.map(
      (detailedReportForDay) {
        final formatRest = DateFormat.yMMMMEEEEd('ar-EG');
        final currentDateInReport = formatRest.format(
          (detailedReportForDay['currentDay'] as Timestamp).toDate(),
        );
        bool isTimeAvailable = true;
        if (detailedReportForDay['todayState'] != 'حاضر') {
          isTimeAvailable = false;
        }
        return ExcelDataRow(
          cells: [
            ExcelDataCell(
              columnHeader: 'اليوم',
              value: currentDateInReport,
            ),
            ExcelDataCell(
              columnHeader: 'الحالة',
              value: detailedReportForDay['todayState'],
            ),
            ExcelDataCell(
              columnHeader: 'الحضور',
              value: isTimeAvailable
                  ? detailedReportForDay['currentDayWorkingFrom']
                  : 'لا يوجد',
            ),
            ExcelDataCell(
              columnHeader: 'الانصراف',
              value: isTimeAvailable
                  ? detailedReportForDay['currentDayWorkingTo']
                  : 'لا يوجد',
            ),
          ],
        );
      },
    ).toList();
    sheet.importData(excelDataRows, 1, 1);
    sheet.autoFitColumn(1);
    final List<int> bytes = workbook.saveAsStream();
    final path = await getApplicationDocumentsDirectory();
    final excelFile =
        await File('${path.path}/employeeInfo.xlsx').writeAsBytes(bytes);
    final downloadUrl =
        await getIt.get<UploadExcelFileToStorage>().run(excelFile, employee);
    loading = false;
    notifyListeners();
    workbook.dispose();
    return downloadUrl;
  }

  Future<String> saveExcelFileAllEmployees(List<Employee> employeesList) async {
    loading = true;
    notifyListeners();
    final workbook = Workbook();
    for (int i = 0; i < employeesList.length; i++) {
      final employee = employeesList[i];
      workbook.worksheets.add();
      final sheet = workbook.worksheets[i];
      sheet.name = employee.name;
      sheet.isRightToLeft = true;
      final List<ExcelDataRow> excelDataRows = employee.detailedReport.map(
        (detailedReportForDay) {
          final formatRest = DateFormat.yMMMMEEEEd('ar-EG');
          final currentDateInReport = formatRest.format(
            (detailedReportForDay['currentDay'] as Timestamp).toDate(),
          );
          bool isTimeAvailable = true;
          if (detailedReportForDay['todayState'] != 'حاضر') {
            isTimeAvailable = false;
          }
          return ExcelDataRow(
            cells: [
              ExcelDataCell(
                columnHeader: 'اليوم',
                value: currentDateInReport,
              ),
              ExcelDataCell(
                columnHeader: 'الحالة',
                value: detailedReportForDay['todayState'],
              ),
              ExcelDataCell(
                columnHeader: 'الحضور',
                value: isTimeAvailable
                    ? detailedReportForDay['currentDayWorkingFrom']
                    : 'لا يوجد',
              ),
              ExcelDataCell(
                columnHeader: 'الانصراف',
                value: isTimeAvailable
                    ? detailedReportForDay['currentDayWorkingTo']
                    : 'لا يوجد',
              ),
            ],
          );
        },
      ).toList();
      sheet.importData(excelDataRows, 1, 1);
      sheet.autoFitColumn(1);
    }
    final List<int> bytes = workbook.saveAsStream();
    final path = await getApplicationDocumentsDirectory();
    final excelFile =
        await File('${path.path}/employeeInfo.xlsx').writeAsBytes(bytes);
    final downloadUrl =
        await getIt.get<UploadExcelFileAllEmployeesToStorage>().run(excelFile);
    loading = false;
    notifyListeners();
    workbook.dispose();
    return downloadUrl;
  }
}
