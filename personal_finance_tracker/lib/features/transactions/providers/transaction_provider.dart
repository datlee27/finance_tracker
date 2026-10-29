import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../data/transaction_repository.dart';
import '../models/transaction_filter.dart';
import '../models/transaction_model.dart';

/// Provider quản lý dữ liệu, bộ lọc và trạng thái giao dịch thu/chi
/// Tách biệt rõ ràng:
/// - Chế độ Đăng nhập: Đồng bộ dữ liệu thực tế từ Cloud Firestore, lưu trữ vĩnh viễn theo tài khoản
/// - Chế độ Khách: Lưu trữ cục bộ theo thiết bị thông qua SharedPreferences
class TransactionProvider extends ChangeNotifier {
  final TransactionRepository? _customRepository;
  StreamSubscription<List<TransactionModel>>? _subscription;

  String? _currentUid;
  bool _isGuest = false;
  List<TransactionModel> _transactions = [];
  TransactionFilter _filter = TransactionFilter.initial();
  bool _isLoading = false;
  String? _errorMessage;

  TransactionProvider({TransactionRepository? repository})
      : _customRepository = repository;

  TransactionRepository get _repository =>
      _customRepository ?? TransactionRepository();

  // Getters
  List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  TransactionFilter get filter => _filter;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get currentUid => _currentUid;
  bool get isGuest => _isGuest;

  /// Danh sách đã lọc theo điều kiện tìm kiếm, loại thu/chi và danh mục
  List<TransactionModel> get filteredTransactions {
    return _transactions.where((t) {
      // 1. Lọc theo Loại (Tất cả / Thu nhập / Chi tiêu)
      if (_filter.type != 'all') {
        if (_filter.type == FirestoreConstants.typeIncome && !t.isIncome) {
          return false;
        }
        if (_filter.type == FirestoreConstants.typeExpense && !t.isExpense) {
          return false;
        }
      }

      // 2. Lọc theo Danh mục
      if (_filter.category != 'all' && _filter.category != 'Tất cả danh mục') {
        if (t.category.toLowerCase() != _filter.category.toLowerCase()) {
          return false;
        }
      }

      // 3. Tìm kiếm theo từ khóa (ghi chú hoặc tên danh mục)
      if (_filter.searchQuery.trim().isNotEmpty) {
        final query = _filter.searchQuery.trim().toLowerCase();
        final matchNote = (t.note ?? '').toLowerCase().contains(query);
        final matchCategory = t.category.toLowerCase().contains(query);
        if (!matchNote && !matchCategory) {
          return false;
        }
      }

      return true;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// 5 giao dịch gần đây nhất để hiển thị ở Trang chủ
  /// Ưu tiên thời gian thao tác (createdAt) để giao dịch người dùng mới thêm/chỉnh sửa
  /// luôn hiển thị ngay lập tức ở vị trí đầu tiên của "Hoạt động mới nhất của bạn"
  List<TransactionModel> get recentTransactions {
    final sorted = List<TransactionModel>.from(_transactions)
      ..sort((a, b) {
        // 1. Giao dịch thao tác mới hơn (createdAt) luôn đứng trước
        final aCreated = a.createdAt;
        final bCreated = b.createdAt;
        if (aCreated != null && bCreated != null) {
          final cmp = bCreated.compareTo(aCreated);
          if (cmp != 0) return cmp;
        } else if (aCreated != null && bCreated == null) {
          return -1;
        } else if (bCreated != null && aCreated == null) {
          return 1;
        }

        // 2. Theo ngày phát sinh giao dịch (date) giảm dần
        final dateCompare = b.date.compareTo(a.date);
        if (dateCompare != 0) return dateCompare;

        return b.id.compareTo(a.id);
      });
    return sorted.take(5).toList();
  }

  /// Tổng thu nhập
  double get totalIncome {
    return _transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Tổng chi tiêu
  double get totalExpense {
    return _transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Số dư hiện tại = Tổng thu nhập - Tổng chi tiêu
  double get balance => totalIncome - totalExpense;

  /// Cập nhật user ID khi AuthProvider thay đổi
  void updateUser(String? uid, {bool isGuest = false}) {
    if (_currentUid == uid && _isGuest == isGuest) return;

    _currentUid = uid;
    _isGuest = isGuest;
    _subscription?.cancel();
    _subscription = null;
    _transactions = [];
    _filter = TransactionFilter.initial();
    _errorMessage = null;

    if (uid != null && uid.isNotEmpty) {
      if (isGuest) {
        _loadGuestData();
      } else {
        _initUserStream(uid);
      }
    } else {
      notifyListeners();
    }
  }

  /// Nạp dữ liệu Chế độ Khách từ bộ nhớ máy (SharedPreferences)
  Future<void> _loadGuestData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final guestData = await _repository.getGuestTransactions();
      _transactions = guestData;
      _isLoading = false;
      _errorMessage = null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi nạp dữ liệu khách: $e';
    }
    notifyListeners();
  }

  /// Khởi tạo realtime stream cho user đăng nhập thật qua Cloud Firestore
  void _initUserStream(String uid) {
    _isLoading = true;
    notifyListeners();

    _subscription = _repository.getTransactionsStream(uid).listen(
      (data) {
        _transactions = data;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Không thể đồng bộ Firestore: $error';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  static int _idCounter = 0;

  /// Thêm giao dịch mới
  Future<bool> addTransaction({
    required String type,
    required double amount,
    required String category,
    required DateTime date,
    String? note,
  }) async {
    final uid = _currentUid ?? 'guest_user_preview';
    final newTransaction = TransactionModel(
      id: 'GD-${DateTime.now().microsecondsSinceEpoch}-${++_idCounter}',
      userId: uid,
      type: type,
      amount: amount,
      category: category,
      date: date,
      note: note,
      createdAt: DateTime.now(),
    );

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (!_isGuest && _currentUid != null && !_currentUid!.startsWith('guest_')) {
        // Người dùng đăng nhập: Ghi trực tiếp lên Cloud Firestore
        final saved = await _repository.addTransaction(uid, newTransaction);
        if (!_transactions.any((t) => t.id == saved.id)) {
          _transactions.insert(0, saved);
        }
      } else {
        // Chế độ Khách: Lưu theo thiết bị qua SharedPreferences
        final saved = await _repository.addGuestTransaction(newTransaction);
        if (!_transactions.any((t) => t.id == saved.id)) {
          _transactions.insert(0, saved);
        }
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (!_transactions.any((t) => t.id == newTransaction.id)) {
        _transactions.insert(0, newTransaction);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  /// Cập nhật giao dịch
  Future<bool> updateTransaction(TransactionModel updated) async {
    final uid = _currentUid ?? 'guest_user_preview';
    final modelToUpdate = updated.copyWith(createdAt: DateTime.now());
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (!_isGuest && _currentUid != null && !_currentUid!.startsWith('guest_')) {
        // Người dùng đăng nhập: Cập nhật lên Cloud Firestore
        await _repository.updateTransaction(uid, modelToUpdate);
      } else {
        // Chế độ Khách: Cập nhật trên máy
        await _repository.updateGuestTransaction(modelToUpdate);
      }
      final index = _transactions.indexWhere((t) => t.id == updated.id);
      if (index != -1) {
        _transactions[index] = modelToUpdate;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      final index = _transactions.indexWhere((t) => t.id == updated.id);
      if (index != -1) {
        _transactions[index] = modelToUpdate;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  /// Xóa giao dịch
  Future<bool> deleteTransaction(String transactionId) async {
    final uid = _currentUid ?? 'guest_user_preview';
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (!_isGuest && _currentUid != null && !_currentUid!.startsWith('guest_')) {
        // Người dùng đăng nhập: Xoá trên Cloud Firestore
        await _repository.deleteTransaction(uid, transactionId);
      } else {
        // Chế độ Khách: Xoá trên máy
        await _repository.deleteGuestTransaction(transactionId);
      }
      _transactions.removeWhere((t) => t.id == transactionId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _transactions.removeWhere((t) => t.id == transactionId);
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  /// Xoá toàn bộ giao dịch (xoá sạch trên máy nếu ở Chế độ Khách và reset state)
  Future<void> clearAllData() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_isGuest) {
        await _repository.clearAllGuestTransactions();
      }
      _transactions.clear();
      _isLoading = false;
      notifyListeners();
    } catch (_) {
      _transactions.clear();
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Các hàm bộ lọc & tìm kiếm ---

  /// Lọc theo loại ('all', 'income', 'expense')
  void setFilterType(String type) {
    _filter = _filter.copyWith(type: type);
    notifyListeners();
  }

  /// Lọc theo danh mục ('all' hoặc tên danh mục)
  void setFilterCategory(String category) {
    _filter = _filter.copyWith(category: category);
    notifyListeners();
  }

  /// Tìm kiếm theo từ khóa
  void setSearchQuery(String query) {
    _filter = _filter.copyWith(searchQuery: query);
    notifyListeners();
  }

  /// Xóa toàn bộ bộ lọc
  void resetFilters() {
    _filter = TransactionFilter.initial();
    notifyListeners();
  }

  /// Xóa thông báo lỗi
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
