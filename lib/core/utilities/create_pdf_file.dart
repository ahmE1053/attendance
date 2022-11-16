import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
import 'package:barcode/barcode.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CreatePdfFile {
  static Future<Uint8List> run(String name, String id, Size mq) async {
    final pdf = pw.Document();
    final font = (await PdfGoogleFonts.cairoExtraBold());
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.BarcodeWidget(
                  padding: pw.EdgeInsets.zero,
                  // height: mq.height * 0.5,
                  data: id,
                  barcode: Barcode.qrCode(),
                  // width: mq.width * 0.9,
                ),
              ),
              pw.Expanded(
                child: pw.FittedBox(
                  fit: pw.BoxFit.scaleDown,
                  child: pw.Text(
                    name,
                    textDirection: pw.TextDirection.rtl,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: mq.width * 0.08, font: font),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
    return await pdf.save();
  }
}
