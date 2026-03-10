import 'package:get/get.dart';

class BookingController extends GetxController {
  var selectedTab = "All".obs;

  RxList orders = [
    {
      "id": "MT10234",
      "labName": "Sahyadri Laboratory",
      "tests": "Full Body Checkup (64 Tests)",
      "status": "Pending",
      "date": "12 Mar • 09:00 AM"
    },
    {
      "id": "MT10235",
      "labName": "Apollo Diagnostics",
      "tests": "Thyroid & Vitamin Profile",
      "status": "Completed",
      "date": "10 Mar • 08:30 AM"
    },
    {
      "id": "MT10236",
      "labName": "Metropolis Healthcare",
      "tests": "Lipid Profile & HbA1c",
      "status": "Pending",
      "date": "14 Mar • 07:45 AM"
    },
    {
      "id": "MT10237",
      "labName": "Dr. Lal PathLabs",
      "tests": "Kidney Function Test (KFT)",
      "status": "Completed",
      "date": "08 Mar • 10:00 AM"
    },
    {
      "id": "MT10238",
      "labName": "SRL Diagnostics",
      "tests": "Vitamin D & B12 Special",
      "status": "Cancelled",
      "date": "05 Mar • 09:15 AM"
    },
    {
      "id": "MT10239",
      "labName": "Thyrocare Technologies",
      "tests": "Iron Deficiency Profile",
      "status": "Completed",
      "date": "02 Mar • 08:00 AM"
    },
    {
      "id": "MT10240",
      "labName": "Medall Healthcare",
      "tests": "Cardiac Risk Markers",
      "status": "Pending",
      "date": "16 Mar • 06:30 AM"
    },
    {
      "id": "MT10241",
      "labName": "Suburban Diagnostics",
      "tests": "Liver Function Test (LFT)",
      "status": "Completed",
      "date": "28 Feb • 09:30 AM"
    },
    {
      "id": "MT10242",
      "labName": "Max Labs",
      "tests": "Post-COVID Health Check",
      "status": "Cancelled",
      "date": "25 Feb • 11:00 AM"
    },
    {
      "id": "MT10243",
      "labName": "Quest Diagnostics",
      "tests": "Allergy Screening (Panel 1)",
      "status": "Pending",
      "date": "18 Mar • 08:45 AM"
    },
    {
      "id": "MT10244",
      "labName": "Lucid Medical Diagnostics",
      "tests": "Bone Health Advanced",
      "status": "Completed",
      "date": "20 Feb • 07:00 AM"
    },
    {
      "id": "MT10245",
      "labName": "Neuberg Diagnostics",
      "tests": "Fertility Profile (Female)",
      "status": "Pending",
      "date": "20 Mar • 10:15 AM"
    },
    {
      "id": "MT10246",
      "labName": "Healthians",
      "tests": "CBC with ESR",
      "status": "Completed",
      "date": "15 Feb • 08:20 AM"
    },
    {
      "id": "MT10247",
      "labName": "Aster Labs",
      "tests": "Diabetes Screening Plus",
      "status": "Pending",
      "date": "22 Mar • 09:00 AM"
    },
    {
      "id": "MT10248",
      "labName": "Vijaya Diagnostics",
      "tests": "Senior Citizen Health Panel",
      "status": "Completed",
      "date": "10 Feb • 06:45 AM"
    }
  ].obs;

  void changeTab(String tab) => selectedTab.value = tab;
}