import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';

/// Data Source lưu trữ dữ liệu cục bộ theo thiết bị (SharedPreferences) dành riêng cho Chế độ Khách (Production)
class LocalGuestTransactionDataSource {
  static const String _storageKey = 'penny_guest_transactions_prod';
  final SharedPreferences? _customPrefs;

  LocalGuestTransactionDataSource({SharedPreferences? prefs})
      : _customPrefs = prefs;

  Future<SharedPreferences> _getPrefs() async {
    return _customPrefs ?? await SharedPreferences.getInstance();
  }

  /// Lấy danh sách giao dịch thật của khách đã lưu trên thiết bị
  /// Không chứa dữ liệu mock/mẫu; ban đầu là danh sách trống
  Future<List<TransactionModel>> getGuestTransactions() async {
    try {
      final prefs = await _getPrefs();
      // Tự động dọn dẹp các key mock cũ nếu còn sót lại từ bản dev
      if (prefs.containsKey('penny_guest_transactions_v2')) {
        await prefs.remove('penny_guest_transactions_v2');
      }
      if (prefs.containsKey('penny_guest_transactions_v1')) {
        await prefs.remove('penny_guest_transactions_v1');
      }

      final jsonStr = prefs.getString(_storageKey);

      if (jsonStr != null && jsonStr.trim().isNotEmpty) {
        final List<dynamic> rawList = jsonDecode(jsonStr) as List<dynamic>;
        return rawList
            .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Ghi đè toàn bộ danh sách giao dịch khách vào máy
  Future<void> saveGuestTransactions(List<TransactionModel> transactions) async {
    try {
      final prefs = await _getPrefs();
      final rawList = transactions.map((t) => t.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(rawList));
    } catch (_) {}
  }

  /// Thêm một giao dịch khách mới và lưu ngay vào máy
  Future<TransactionModel> addGuestTransaction(TransactionModel transaction) async {
    final list = await getGuestTransactions();
    final updatedList = [transaction, ...list];
    await saveGuestTransactions(updatedList);
    return transaction;
  }

  /// Cập nhật giao dịch khách và lưu vào máy
  Future<void> updateGuestTransaction(TransactionModel transaction) async {
    final list = await getGuestTransactions();
    final index = list.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      list[index] = transaction;
      await saveGuestTransactions(list);
    }
  }

  /// Xóa giao dịch khách và cập nhật bộ nhớ máy
  Future<void> deleteGuestTransaction(String transactionId) async {
    final list = await getGuestTransactions();
    list.removeWhere((t) => t.id == transactionId);
    await saveGuestTransactions(list);
  }

  /// Xoá toàn bộ dữ liệu khách trên máy (dùng khi reset dữ liệu)
  Future<void> clearAllGuestTransactions() async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove(_storageKey);
    } catch (_) {}
  }
}
