import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_constants.dart';

/// Model đại diện cho một bản ghi giao dịch thu/chi
class TransactionModel {
  final String id;
  final String userId;
  final String type; // 'income' hoặc 'expense'
  final double amount;
  final String category;
  final DateTime date;
  final String? note;
  final DateTime? createdAt;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
    this.createdAt,
  });

  bool get isIncome => type.toLowerCase() == FirestoreConstants.typeIncome;
  bool get isExpense => type.toLowerCase() == FirestoreConstants.typeExpense;

  /// Tên loại giao dịch tiếng Việt
  String get kind => isIncome ? 'Thu nhập' : 'Chi tiêu';

  /// Ghi chú hiển thị an toàn
  String get noteDisplay =>
      (note != null && note!.trim().isNotEmpty) ? note!.trim() : category;

  /// Trong môi trường production, tất cả các bản ghi đều là dữ liệu thực tế của người dùng
  bool get isSeedItem => false;

  /// Tạo TransactionModel từ Firestore DocumentSnapshot
  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return TransactionModel.fromMap(data, doc.id);
  }

  /// Tạo TransactionModel từ Map
  factory TransactionModel.fromMap(Map<String, dynamic> map, String docId) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return TransactionModel(
      id: docId,
      userId: map['userId'] as String? ?? '',
      type: (map[FirestoreConstants.fieldType] as String?)?.toLowerCase() ??
          FirestoreConstants.typeExpense,
      amount: (map[FirestoreConstants.fieldAmount] as num?)?.toDouble() ?? 0.0,
      category: map[FirestoreConstants.fieldCategory] as String? ?? 'Khác',
      date: parseDate(map[FirestoreConstants.fieldDate]),
      note: map[FirestoreConstants.fieldNote] as String?,
      createdAt: map[FirestoreConstants.fieldCreatedAt] != null
          ? parseDate(map[FirestoreConstants.fieldCreatedAt])
          : null,
    );
  }

  /// Chuyển TransactionModel thành Map để lưu lên Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      FirestoreConstants.fieldType: type,
      FirestoreConstants.fieldAmount: amount,
      FirestoreConstants.fieldCategory: category,
      FirestoreConstants.fieldDate: Timestamp.fromDate(date),
      FirestoreConstants.fieldNote: note?.trim() ?? '',
      FirestoreConstants.fieldCreatedAt:
          Timestamp.fromDate(createdAt ?? date),
    };
  }

  /// Chuyển TransactionModel thành JSON Map để lưu cục bộ SharedPreferences (cho Chế độ Khách)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
      'createdAt': (createdAt ?? date).toIso8601String(),
    };
  }

  /// Tạo TransactionModel từ JSON Map đã lưu ở SharedPreferences
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic val) {
      if (val is String) {
        return DateTime.tryParse(val) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return TransactionModel(
      id: json['id'] as String? ?? 'GD-${DateTime.now().millisecondsSinceEpoch}',
      userId: json['userId'] as String? ?? 'guest_user_preview',
      type: (json['type'] as String?)?.toLowerCase() ?? FirestoreConstants.typeExpense,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? 'Khác',
      date: parseDate(json['date']),
      note: json['note'] as String?,
      createdAt: json['createdAt'] != null ? parseDate(json['createdAt']) : null,
    );
  }

  /// Tạo bản sao có cập nhật trường
  TransactionModel copyWith({
    String? id,
    String? userId,
    String? type,
    double? amount,
    String? category,
    DateTime? date,
    String? note,
    DateTime? createdAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
