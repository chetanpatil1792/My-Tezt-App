// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/rendering.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:printing/printing.dart';
// import 'package:share_plus/share_plus.dart';
//
// Future<void> _captureAndSharePdf(Map<String, dynamic> data) async {
//   try {
//     // Capture the widget as image
//     RenderRepaintBoundary boundary =
//     _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//     ui.Image image = await boundary.toImage(pixelRatio: 3.0); // High quality
//     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//     Uint8List pngBytes = byteData!.buffer.asUint8List();
//
//     // Convert image to PDF
//     final pdf = pw.Document();
//     final imagePdf = pw.MemoryImage(pngBytes);
//     pdf.addPage(pw.Page(build: (pw.Context context) {
//       return pw.Center(child: pw.Image(imagePdf));
//     }));
//
//     // Save PDF locally
//     final output = await getTemporaryDirectory();
//     final file = File("${output.path}/lab_report.pdf");
//     await file.writeAsBytes(await pdf.save());
//
//     // Share PDF
//     await Share.shareFiles([file.path], text: 'Lab Report');
//
//   } catch (e) {
//     print("Error capturing report: $e");
//   }
// }
