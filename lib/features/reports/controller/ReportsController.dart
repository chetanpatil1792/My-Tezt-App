import 'package:get/get.dart';

class ReportsController extends GetxController {
  final List<Map<String, dynamic>> allReports = [
    {
      "id": "REP101",
      "title": "Complete Blood Count (CBC)",
      "labName": "ShobiLab Diagnostics",
      "date": "22 Oct 2023",
      "status": "Final",
      "type": "Blood Test",
      "doctor": "Dr. Aarav Sharma",
      "results": [
        {"parameter": "Hemoglobin", "value": "14.2", "unit": "g/dL", "range": "13.0 - 17.0", "status": "Normal"},
        {"parameter": "RBC Count", "value": "5.1", "unit": "million/mcL", "range": "4.5 - 5.9", "status": "Normal"},
        {"parameter": "WBC Count", "value": "8500", "unit": "/mcL", "range": "4500 - 11000", "status": "Normal"},
        {"parameter": "Platelets", "value": "250000", "unit": "/mcL", "range": "150000 - 450000", "status": "Normal"},
      ]
    },
    {
      "id": "REP102",
      "title": "Lipid Profile",
      "labName": "Apollo PathLabs",
      "date": "15 Oct 2023",
      "status": "Final",
      "type": "Biochemistry",
      "doctor": "Dr. Ishani Verma",
      "results": [
        {"parameter": "Total Cholesterol", "value": "210", "unit": "mg/dL", "range": "< 200", "status": "High"},
        {"parameter": "Triglycerides", "value": "160", "unit": "mg/dL", "range": "< 150", "status": "High"},
        {"parameter": "HDL Cholesterol", "value": "45", "unit": "mg/dL", "range": "> 40", "status": "Normal"},
        {"parameter": "LDL Cholesterol", "value": "130", "unit": "mg/dL", "range": "< 100", "status": "High"},
      ]
    },
    {
      "id": "REP103",
      "title": "Vitamin D (25-OH)",
      "labName": "Dr. Lal PathLabs",
      "date": "05 Oct 2023",
      "status": "Final",
      "type": "Hormones",
      "doctor": "Dr. Rohan Gupta",
      "results": [
        {"parameter": "Vitamin D", "value": "24.5", "unit": "ng/mL", "range": "30.0 - 100.0", "status": "Low"},
      ]
    },
  ];

  late Map<String, dynamic> selectedReport;

  void selectReport(Map<String, dynamic> report) {
    selectedReport = report;
  }
}