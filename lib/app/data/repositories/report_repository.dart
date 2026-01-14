// app/data/repositories/report_repository.dart
import 'package:get/get.dart';
import '../providers/api_provider.dart';
import '../models/report_model.dart';
import '../../utils/constants.dart' show ApiEndpoints;

class ReportRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<List<Report>> getReports() async {
    final response = await _apiProvider.get(ApiEndpoints.reports);
    final List reports = response['reports'] ?? response['data'] ?? [];
    return reports.map((report) => Report.fromJson(report)).toList();
  }

  Future<Report> createReport({
    required String title,
    required String description,
    required String reportType,
  }) async {
    final response = await _apiProvider.post(ApiEndpoints.reports, {
      'title': title,
      'description': description,
      'reportType': reportType,
    });
    return Report.fromJson(response['report'] ?? response['data']);
  }

  Future<void> deleteReport(String id) async {
    await _apiProvider.delete('${ApiEndpoints.reports}/$id');
  }

  // Get reports by type
  Future<List<Report>> getReportsByType(ReportType type) async {
    final response = await _apiProvider.get(
      '${ApiEndpoints.reports}?type=${type.value}',
    );
    final List reports = response['reports'] ?? response['data'] ?? [];
    return reports.map((report) => Report.fromJson(report)).toList();
  }

  // Get user's reports
  Future<List<Report>> getMyReports() async {
    final response = await _apiProvider.get(
      '${ApiEndpoints.reports}/my-reports',
    );
    final List reports = response['reports'] ?? response['data'] ?? [];
    return reports.map((report) => Report.fromJson(report)).toList();
  }
}
