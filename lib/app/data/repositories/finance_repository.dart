// app/modules/business/repositories/finance_repository.dart
import 'package:ebee/app/data/providers/api_provider.dart' show ApiProvider;
import 'package:get/get.dart';

class FinanceRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<List<dynamic>> getTransactions() async {
    try {
      final response = await _apiProvider.get('/finance/transactions');
      return response['data'] ?? [];
    } catch (e) {
      throw 'Failed to load transactions: $e';
    }
  }

  Future<Map<String, dynamic>> getRevenueData() async {
    try {
      final response = await _apiProvider.get('/finance/revenue');
      return response['data'] ?? {};
    } catch (e) {
      throw 'Failed to load revenue data: $e';
    }
  }

  Future<Map<String, dynamic>> getExpenseData() async {
    try {
      final response = await _apiProvider.get('/finance/expenses');
      return response['data'] ?? {};
    } catch (e) {
      throw 'Failed to load expense data: $e';
    }
  }

  Future<List<dynamic>> getReports() async {
    try {
      final response = await _apiProvider.get('/finance/reports');
      return response['data'] ?? [];
    } catch (e) {
      throw 'Failed to load reports: $e';
    }
  }

  Future<void> generateReport(String type) async {
    try {
      await _apiProvider.post('/finance/reports/generate', {'type': type});
    } catch (e) {
      throw 'Failed to generate report: $e';
    }
  }
}
