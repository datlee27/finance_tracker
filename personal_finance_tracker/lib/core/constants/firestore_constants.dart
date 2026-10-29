// Tên collection và field của Cloud Firestore
class FirestoreConstants {
  FirestoreConstants._();

  // Collections
  static const String usersCollection = 'users';
  static const String transactionsCollection = 'transactions';

  // Transaction fields
  static const String fieldId = 'id';
  static const String fieldType = 'type';
  static const String fieldAmount = 'amount';
  static const String fieldCategory = 'category';
  static const String fieldDate = 'date';
  static const String fieldNote = 'note';
  static const String fieldCreatedAt = 'createdAt';

  // Transaction types
  static const String typeIncome = 'income';
  static const String typeExpense = 'expense';
}
