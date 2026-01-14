// app/modules/reports/controllers/report_controller.dart
import 'package:get/get.dart';
import '../../../data/repositories/report_repository.dart';
import '../../../data/models/report_model.dart';

class ReportController extends GetxController {
  final ReportRepository _reportRepository = ReportRepository();

  var isLoading = false.obs;
  var reports = <Report>[].obs;
  var filteredReports = <Report>[].obs;
  var selectedReportType = ReportType.custom.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    getReports();
    super.onInit();
  }

  Future<void> getReports() async {
    try {
      isLoading.value = true;
      final List<Report> reportList = await _reportRepository.getReports();
      reports.assignAll(reportList);
      filterReports();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load reports: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createReport({
    required String title,
    required String description,
    required ReportType reportType,
  }) async {
    try {
      isLoading.value = true;
      final Report report = await _reportRepository.createReport(
        title: title,
        description: description,
        reportType: reportType.value,
      );
      reports.insert(0, report);
      filterReports();
      Get.snackbar('Success', 'Report submitted successfully');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit report: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteReport(String reportId) async {
    try {
      await _reportRepository.deleteReport(reportId);
      reports.removeWhere((report) => report.id == reportId);
      filterReports();
      Get.snackbar('Success', 'Report deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete report: $e');
    }
  }

  void filterReports() {
    var filtered = reports.where((report) {
      final matchesType =
          selectedReportType.value == ReportType.custom ||
          report.type == selectedReportType.value;
      final matchesSearch =
          searchQuery.value.isEmpty ||
          report.title.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ) ||
          report.content.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );
      return matchesType && matchesSearch;
    }).toList();

    filteredReports.assignAll(filtered);
  }

  void setReportType(ReportType type) {
    selectedReportType.value = type;
    filterReports();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    filterReports();
  }

  void clearFilters() {
    selectedReportType.value = ReportType.custom;
    searchQuery.value = '';
    filterReports();
  }

  // Statistics
  int get totalReports => reports.length;
  int get filteredReportsCount => filteredReports.length;

  int get ordersReportsCount =>
      reports.where((r) => r.type == ReportType.orders).length;
  int get rentalsReportsCount =>
      reports.where((r) => r.type == ReportType.rentals).length;
  int get paymentsReportsCount =>
      reports.where((r) => r.type == ReportType.payments).length;
  int get inventoryReportsCount =>
      reports.where((r) => r.type == ReportType.inventory).length;
  int get feedbackReportsCount =>
      reports.where((r) => r.type == ReportType.feedback).length;
  int get customReportsCount =>
      reports.where((r) => r.type == ReportType.custom).length;

  // Get recent reports (last 7 days)
  List<Report> get recentReports {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return reports
        .where((report) => report.createdAt.isAfter(weekAgo))
        .toList();
  }
}
