// app/modules/fines/controllers/fine_controller.dart
import 'package:get/get.dart';
import '../../../data/repositories/fine_repository.dart';
import '../../../data/models/fine_model.dart';

class FineController extends GetxController {
  final FineRepository _fineRepository = FineRepository();

  var isLoading = false.obs;
  var fines = <Fine>[].obs;
  var filteredFines = <Fine>[].obs;
  var selectedFine = Rxn<Fine>();

  // Filtering
  var searchQuery = ''.obs;
  var amountFilter = 'all'.obs; // all, low, medium, high
  var statusFilter = 'all'.obs; // all, paid, unpaid

  @override
  void onInit() {
    getFines();
    super.onInit();
  }

  Future<void> getFines() async {
    try {
      isLoading.value = true;
      final List<Fine> fineList = await _fineRepository.getFines();
      fines.assignAll(fineList);
      filterFines();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load fines: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createFine({
    required String reason,
    required double amount,
    required String rentalId,
    required String userId,
  }) async {
    try {
      isLoading.value = true;
      final Fine fine = await _fineRepository.createFine(
        reason: reason,
        amount: amount,
        rentalId: rentalId,
        userId: userId,
      );
      fines.add(fine);
      filterFines();
      Get.snackbar('Success', 'Fine created successfully');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to create fine: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateFine(String fineId, Map<String, dynamic> updates) async {
    try {
      final Fine updatedFine = await _fineRepository.updateFine(
        fineId,
        updates,
      );
      final index = fines.indexWhere((fine) => fine.id == fineId);
      if (index != -1) {
        fines[index] = updatedFine;
      }
      filterFines();
      Get.snackbar('Success', 'Fine updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update fine: $e');
    }
  }

  Future<void> deleteFine(String fineId) async {
    try {
      await _fineRepository.deleteFine(fineId);
      fines.removeWhere((fine) => fine.id == fineId);
      filterFines();
      Get.snackbar('Success', 'Fine deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete fine: $e');
    }
  }

  Future<void> markAsPaid(String fineId) async {
    try {
      final Fine paidFine = await _fineRepository.markAsPaid(fineId);
      final index = fines.indexWhere((fine) => fine.id == fineId);
      if (index != -1) {
        fines[index] = paidFine;
      }
      filterFines();
      Get.snackbar('Success', 'Fine marked as paid');
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark fine as paid: $e');
    }
  }

  Future<void> waiveFine(String fineId) async {
    try {
      final Fine waivedFine = await _fineRepository.waiveFine(fineId);
      final index = fines.indexWhere((fine) => fine.id == fineId);
      if (index != -1) {
        fines[index] = waivedFine;
      }
      filterFines();
      Get.snackbar('Success', 'Fine waived successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to waive fine: $e');
    }
  }

  void filterFines() {
    var filtered = fines.where((fine) {
      // Amount filter
      final matchesAmount =
          amountFilter.value == 'all' ||
          (amountFilter.value == 'low' && fine.isLowAmount) ||
          (amountFilter.value == 'medium' && fine.isMediumAmount) ||
          (amountFilter.value == 'high' && fine.isHighAmount);

      // Status filter (simplified - you might want to add paid field)
      final matchesStatus =
          statusFilter.value == 'all' ||
          (statusFilter.value == 'paid' && fine.isPaid) ||
          (statusFilter.value == 'unpaid' && !fine.isPaid);

      // Search filter
      final matchesSearch =
          searchQuery.value.isEmpty ||
          fine.reason.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          fine.userName.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ) ||
          fine.productName.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );

      return matchesAmount && matchesStatus && matchesSearch;
    }).toList();

    filteredFines.assignAll(filtered);
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    filterFines();
  }

  void setAmountFilter(String filter) {
    amountFilter.value = filter;
    filterFines();
  }

  void setStatusFilter(String filter) {
    statusFilter.value = filter;
    filterFines();
  }

  void clearFilters() {
    searchQuery.value = '';
    amountFilter.value = 'all';
    statusFilter.value = 'all';
    filterFines();
  }

  // Statistics
  int get totalFines => fines.length;
  double get totalFinesAmount =>
      fines.fold(0.0, (sum, fine) => sum + fine.amount);
  double get averageFineAmount =>
      totalFines > 0 ? totalFinesAmount / totalFines : 0;

  int get lowAmountFines => fines.where((fine) => fine.isLowAmount).length;
  int get mediumAmountFines =>
      fines.where((fine) => fine.isMediumAmount).length;
  int get highAmountFines => fines.where((fine) => fine.isHighAmount).length;

  int get unpaidFinesCount => fines.where((fine) => !fine.isPaid).length;
  int get paidFinesCount => fines.where((fine) => fine.isPaid).length;

  double get unpaidFinesAmount {
    return fines
        .where((fine) => !fine.isPaid)
        .fold(0.0, (sum, fine) => sum + fine.amount);
  }

  // Get recent fines (last 30 days)
  List<Fine> get recentFines {
    final monthAgo = DateTime.now().subtract(const Duration(days: 30));
    return fines.where((fine) => fine.createdAt.isAfter(monthAgo)).toList();
  }

  // Get fines that require attention (unpaid and overdue)
  List<Fine> get attentionRequiredFines {
    return fines.where((fine) => fine.isOverdue && !fine.isPaid).toList();
  }
}
