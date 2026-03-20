import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../../../core/constants/appcolors.dart';

class ReportDetailScreen extends StatelessWidget {
  ReportDetailScreen({super.key});

  final GlobalKey _globalKey = GlobalKey(); // Key for capturing widget

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = Get.arguments;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF2F2F2),
        iconTheme: IconThemeData(color: primaryDarkBlue),
        title: const Text("LAB REPORT"),
        actions: [
          IconButton(
            tooltip: 'Share PDF',
            onPressed: () => _sharePdf(data),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 5, right: 5),
          child: RepaintBoundary(
            key: _globalKey,
            child: Container(
              width: 820,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black26),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(data),
                  const SizedBox(height: 18),
                  _patientBlock(data),
                  const SizedBox(height: 18),
                  _resultTable(data),
                  const SizedBox(height: 24),
                  _footer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= PDF GENERATION =================
  Future<File> _generatePdf(Map<String, dynamic> data) async {
    RenderRepaintBoundary boundary =
    _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final pdf = pw.Document();
    final imagePdf = pw.MemoryImage(pngBytes);
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => pw.Center(child: pw.Image(imagePdf)),
    ));

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/lab_report.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // ================= DOWNLOAD =================
  Future<void> _downloadPdf(Map<String, dynamic> data, BuildContext context) async {
    try {
      final file = await _generatePdf(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF downloaded: ${file.path}')),
      );
    } catch (e) {
      print("Download error: $e");
    }
  }

  // ================= SHARE =================
  Future<void> _sharePdf(Map<String, dynamic> data) async {
    try {
      final file = await _generatePdf(data);
      await Share.shareXFiles([XFile(file.path)], text: 'Lab Report');
    } catch (e) {
      print("Share error: $e");
    }
  }

  // ================= HEADER =================
  Widget _header(Map data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                data['labName'].toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: primaryDarkBlue,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "ISO 9001:2015 & NABL Certified Laboratory",
                style: TextStyle(fontSize: 11),
              ),
            ]),
            Image.network(
              "https://cdn-icons-png.flaticon.com/512/2966/2966327.png",
              height: 42,
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(thickness: 1),
      ],
    );
  }

  // ================= PATIENT INFO =================
  Widget _patientBlock(Map data) {
    TextStyle label = const TextStyle(fontSize: 11, color: Colors.black54);
    TextStyle value = const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);

    return Column(
      children: [
        Row(
          children: [
            _info("Patient Name", "John Doe", label, value),
            _info("Report ID", data['id'], label, value),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _info("Age / Gender", "28Y / Male", label, value),
            _info("Date", data['date'], label, value),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _info("Referred By", data['doctor'], label, value),
            _info("Sample Type", data['type'], label, value),
          ],
        ),
        const Divider(height: 24),
      ],
    );
  }

  Widget _info(String l, String v, TextStyle label, TextStyle value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l, style: label),
          const SizedBox(height: 2),
          Text(v, style: value),
        ],
      ),
    );
  }

  // ================= RESULT TABLE =================
  Widget _resultTable(Map data) {
    final List results = data['results'] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black)),
          ),
          child: const Row(
            children: [
              Expanded(flex: 3, child: Text("Test Parameter", style: _th)),
              Expanded(flex: 2, child: Text("Result", style: _th)),
              Expanded(flex: 2, child: Text("Units", style: _th)),
              Expanded(flex: 3, child: Text("Reference Range", style: _th)),
            ],
          ),
        ),
        ...results.map((r) {
          final bool normal = r['status'] == "Normal";
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text(r['parameter'], style: _td)),
                Expanded(
                  flex: 2,
                  child: Text(
                    r['value'],
                    style: _td.copyWith(
                      fontWeight: FontWeight.w700,
                      color: normal ? Colors.black : Colors.red.shade700,
                    ),
                  ),
                ),
                Expanded(flex: 2, child: Text(r['unit'], style: _td)),
                Expanded(flex: 3, child: Text(r['range'], style: _td)),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  // ================= FOOTER =================
  Widget _footer() {
    return Column(
      children: [
        const Divider(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sign("Technician", "Lab Assistant"),
            _sign("Dr. S. K. Gupta", "Pathologist (MD)", image: true),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          "This is a computer generated report and does not require physical signature.",
          style: TextStyle(fontSize: 9, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _sign(String name, String role, {bool image = false}) {
    return Column(
      children: [
        if (image)
          Image.network(
            "https://cdn.pixabay.com/photo/2016/02/11/19/03/michael-jackson-1194286_1280.png",
            height: 38,
          )
        else
          Container(height: 38),
        Container(width: 100, height: 1, color: Colors.black),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        Text(role, style: const TextStyle(fontSize: 9)),
      ],
    );
  }
}

// ================= TEXT STYLES =================
const TextStyle _th = TextStyle(fontSize: 11, fontWeight: FontWeight.w700);
const TextStyle _td = TextStyle(fontSize: 11, height: 1.4);
