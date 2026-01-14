// app/modules/business/controllers/finance_controller.dart
import 'package:get/get.dart';

class FinanceController extends GetxController {
  var transactions = [].obs;
  var revenueData = {}.obs;
  var expenseData = {}.obs;
  var reports = [].obs;
  var isLoading = false.obs;
  var overview = {
    'totalRevenue': 0,
    'totalExpenses': 0,
    'netProfit': 0,
    'revenueGrowth': 0,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    loadFinanceData();
  }

  void loadFinanceData() async {
    isLoading.value = true;

    try {
      // Simulate loading data
      await Future.delayed(const Duration(seconds: 2));

      // Mock data
      transactions.value = List.generate(
        10,
        (index) => _createMockTransaction(index),
      );
      revenueData.value = _createMockRevenueData();
      expenseData.value = _createMockExpenseData();
      reports.value = _createMockReports();
      _updateOverview();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load finance data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateOverview() {
    final totalRevenue = transactions
        .where((t) => t['type'] == 'income')
        .fold(0.0, (sum, t) => sum + (t['amount'] ?? 0));

    final totalExpenses = transactions
        .where((t) => t['type'] == 'expense')
        .fold(0.0, (sum, t) => sum + (t['amount'] ?? 0));

    overview.update('totalRevenue', (value) => totalRevenue);
    overview.update('totalExpenses', (value) => totalExpenses);
    overview.update('netProfit', (value) => totalRevenue - totalExpenses);
  }

  Map<String, dynamic> _createMockTransaction(int index) {
    final isIncome = index % 3 == 0;
    return {
      'id': '${1000 + index}',
      'type': isIncome ? 'income' : 'expense',
      'description': isIncome ? 'Payment Received' : 'Expense Paid',
      'amount': isIncome ? 150.0 + index * 20 : 50.0 + index * 10,
      'date': DateTime.now().subtract(Duration(days: index)),
      'category': isIncome ? 'Sales' : 'Operations',
    };
  }

  Map<String, dynamic> _createMockRevenueData() {
    return {
      'total': 12456,
      'byCategory': {'E-Bike Sales': 8450, 'Rentals': 2340, 'Services': 1666},
      'monthlyGrowth': 12.5,
    };
  }

  Map<String, dynamic> _createMockExpenseData() {
    return {
      'total': 8234,
      'byCategory': {
        'Inventory': 4560,
        'Salaries': 2100,
        'Operations': 1234,
        'Marketing': 340,
      },
      'monthlyChange': -5.2,
    };
  }

  List<Map<String, dynamic>> _createMockReports() {
    return [
      {
        'id': '1',
        'name': 'Monthly Report - November 2024',
        'type': 'monthly',
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'size': '2.4 MB',
      },
      {
        'id': '2',
        'name': 'Quarterly Summary Q4 2024',
        'type': 'quarterly',
        'date': DateTime.now().subtract(const Duration(days: 15)),
        'size': '4.1 MB',
      },
      {
        'id': '3',
        'name': 'Tax Report 2024',
        'type': 'tax',
        'date': DateTime.now().subtract(const Duration(days: 30)),
        'size': '3.2 MB',
      },
    ];
  }
}
