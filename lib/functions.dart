import 'dart:typed_data';

import 'package:attendance_web_app/attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:universal_html/html.dart' as html;

void exportToExcel(String docId) async {
  List<ActivityInfo> activityInfos = [];
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('attendance').get();
    for (var doc in querySnapshot.docs) {
      // Convert Firestore document data to ActivityInfo instance
      activityInfos.add(ActivityInfo(
        date: doc['date'],
        time: doc['time'],
        name: doc['name'],
        phone: doc['phone'],
        email: doc['email'],
        sex: doc['sex'],
        sector: doc['sector'],
        purpose: doc['purpose'],
      ));
    }

    // Create Excel file
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Add header row
    sheetObject.appendRow([
      const TextCellValue('Date'),
      const TextCellValue('Time'),
      const TextCellValue('Name'),
      const TextCellValue('Phone Number'),
      const TextCellValue('Email'),
      const TextCellValue('Sex'),
      const TextCellValue('Sector'),
      const TextCellValue('Purpose of Visit'),
    ]);

    // Add data to Excel sheet
    for (var activityInfo in activityInfos) {
      sheetObject.appendRow([
        TextCellValue(activityInfo.date),
        TextCellValue(activityInfo.time),
        TextCellValue(activityInfo.name),
        TextCellValue(activityInfo.phone),
        TextCellValue(activityInfo.email),
        TextCellValue(activityInfo.sex),
        TextCellValue(activityInfo.sector),
        TextCellValue(activityInfo.purpose),
      ]);
    }

    // Save Excel file as byte data
    List<int>? excelData = excel.encode();

    // Convert byte data to Blob
    final blob = html.Blob([
      Uint8List.fromList(excelData!)
    ], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

    // Create download link
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", "$docId.xlsx")
      ..click();

    // Revoke the object URL to free up resources
    html.Url.revokeObjectUrl(url);
  } catch (e) {
    print("Error exporting to Excel: $e");
  }
}
