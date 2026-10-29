# 📋 QUY TRÌNH & TIẾN ĐỘ THỰC HIỆN DỰ ÁN (WORKFLOW TRACKER)
> **Dự án**: Personal Finance Tracker (PRM393 - Practical Exam)  
> **Kiến trúc**: Provider + Firebase Auth + Cloud Firestore + Material 3  

---

## 🚦 BẢNG ĐIỀU KHIỂN TIẾN ĐỘ (STATUS TRACKER)

| Giai đoạn | Nội dung | Trạng thái | Đánh dấu |
| :--- | :--- | :---: | :---: |
| **Giai đoạn 1** | Khởi tạo dự án, cây thư mục, Core layer, Skeleton | **ĐÃ HOÀN THÀNH** | [x] |
| **Giai đoạn 2** | Auth (Model, DataSource, Repo, Provider, UI, Session, Logout) | **ĐÃ HOÀN THÀNH** | [x] |
| **Giai đoạn 3** | Categories & Transactions (CRUD, Search, Filter, UI, Provider) | **ĐÃ HOÀN THÀNH** | [x] |
| **Giai đoạn 4** | Dashboard & Shell (Dashboard Provider, Widgets, MainShell) | **ĐÃ HOÀN THÀNH** | [x] |
| **Giai đoạn 5** | Security Rules, Unit Tests (mocktail), Clean Lint | **ĐÃ HOÀN THÀNH** | [x] |
| **Giai đoạn 6** | Hoàn thiện tài liệu (`test_cases.md` & `report.md`) | **SẴN SÀNG TRIỂN KHAI** | [ ] |

---

## 📌 NGUYÊN TẮC BẮT BUỘC DÀNH CHO AI (STRICT PROTOCOL)

1. **Kiểm tra trạng thái**: Trước khi code bất kỳ tính năng nào, AI **phải đọc file này** để xác định chính xác giai đoạn hiện tại.
2. **Không làm vượt cấp**: Tuyệt đối **không code trước** các tính năng của giai đoạn sau.
3. **Tiêu chuẩn nghiệm thu**: Mỗi giai đoạn hoàn thành phải chạy `flutter analyze` đạt **0 errors, 0 warnings** trước khi bàn giao.
4. **Dừng và Báo cáo**: Sau khi code xong một giai đoạn:
   - Cập nhật dấu `[x]` và trạng thái tương ứng trong file này.
   - DỪNG LẠI, tóm tắt kết quả, hướng dẫn test/kiểm tra.
   - Chờ lệnh hoặc xác nhận từ người dùng mới được chuyển sang giai đoạn tiếp theo.

---

## 📑 CHI TIẾT CÁC GIAI ĐOẠN

### 🟢 GIAI ĐOẠN 1: KHỞI TẠO DỰ ÁN & CORE LAYER
- [x] Tạo project Flutter `personal_finance_tracker`
- [x] Cập nhật dependencies trong `pubspec.yaml`
- [x] Tạo toàn bộ 63 files skeleton theo cấu trúc bắt buộc
- [x] Hoàn thiện Core Layer:
  - [x] `lib/core/constants/` (`app_constants.dart`, `firestore_constants.dart`)
  - [x] `lib/core/theme/` (`app_theme.dart`, `app_colors.dart`, `app_text_styles.dart`)
  - [x] `lib/core/utils/` (`currency_formatter.dart`, `date_formatter.dart`, `validators.dart`)
  - [x] `lib/core/errors/` (`app_exception.dart`)
  - [x] `lib/core/widgets/` (`app_button.dart`, `app_text_field.dart`, `loading_view.dart`, `error_view.dart`, `empty_state.dart`)
- [x] Cấu hình wiring Provider trong `lib/main.dart` & `lib/app.dart`
- [x] Cấu hình file `firestore.rules` & `firebase.json`
- [x] `flutter analyze` sạch (No issues found)

---

### 🟢 GIAI ĐOẠN 2: AUTHENTICATION MODULE
> **Mục tiêu**: Đăng ký, đăng nhập, tự động khôi phục phiên (session persistence), đăng xuất xóa stack.

- [x] **Model & Data**:
  - [x] Hoàn thiện `lib/features/auth/models/app_user.dart`
  - [x] Hoàn thiện `lib/features/auth/data/firebase_auth_data_source.dart` (xử lý exception map sang tiếng Việt)
  - [x] Hoàn thiện `lib/features/auth/data/auth_repository.dart`
- [x] **Provider**:
  - [x] Hoàn thiện `lib/features/auth/providers/auth_provider.dart` (lắng nghe `authStateChanges`, login, register, logout, status enum)
- [x] **UI & Widgets**:
  - [x] `lib/features/auth/widgets/auth_header.dart`
  - [x] `lib/features/auth/widgets/login_form.dart`
  - [x] `lib/features/auth/screens/splash_screen.dart` (lắng nghe trạng thái auth đầu tiên để điều hướng)
  - [x] `lib/features/auth/screens/login_screen.dart`
  - [x] `lib/features/auth/screens/register_screen.dart`
- [x] **Navigation & Session**:
  - [x] Hoàn thiện điều hướng trong `lib/navigation/app_router.dart`
  - [x] Logout: Xóa session và route về `LoginScreen`, xóa stack navigation (`pushNamedAndRemoveUntil`)
- [x] **Checklist hoàn thành**: `flutter analyze` không lỗi, sẵn sàng kết nối Firebase Auth.

---

### 🟢 GIAI ĐOẠN 3: CATEGORIES & TRANSACTIONS (CRUD)
> **Mục tiêu**: Quản lý danh mục cố định và thao tác CRUD giao dịch với Cloud Firestore theo user ID.

- [x] **Categories**:
  - [x] `lib/features/categories/models/transaction_category.dart`
  - [x] `lib/features/categories/data/category_repository.dart` (danh mục thu & chi cố định trong code kèm icon/màu sắc)
- [x] **Transactions Model & Data**:
  - [x] `lib/features/transactions/models/transaction_model.dart` (fromFirestore/toFirestore/copyWith)
  - [x] `lib/features/transactions/models/transaction_filter.dart`
  - [x] `lib/features/transactions/data/firestore_transaction_data_source.dart` (subcollection `users/{uid}/transactions`)
  - [x] `lib/features/transactions/data/transaction_repository.dart`
- [x] **Provider**:
  - [x] `lib/features/transactions/providers/transaction_provider.dart`
  - [x] Cơ chế realtime subscription theo `uid`
  - [x] Hủy subscription và xóa sạch data khi `uid == null` hoặc đổi tài khoản
  - [x] Tìm kiếm (search by note/category) & Lọc (filter by type/category) client-side
- [x] **UI & Dialog**:
  - [x] `lib/shared/widgets/confirm_delete_dialog.dart`
  - [x] `lib/features/transactions/widgets/transaction_tile.dart`
  - [x] `lib/features/transactions/widgets/transaction_type_selector.dart`
  - [x] `lib/features/transactions/widgets/transaction_search_bar.dart`
  - [x] `lib/features/transactions/widgets/transaction_filter_sheet.dart`
  - [x] `lib/features/transactions/widgets/transaction_form_fields.dart`
  - [x] `lib/features/transactions/screens/transaction_list_screen.dart`
  - [x] `lib/features/transactions/screens/transaction_detail_screen.dart`
  - [x] `lib/features/transactions/screens/transaction_form_screen.dart` (dùng chung cho Add/Edit)
- [x] **Checklist hoàn thành**: `flutter analyze` không lỗi.

---

### 🟢 GIAI ĐOẠN 4: DASHBOARD & WIRING TOÀN BỘ
> **Mục tiêu**: Hiển thị tổng quan thu/chi/số dư, gắn kết các tab trên MainShell, nút Logout tại DashboardHeader.

- [x] **Dashboard Provider**:
  - [x] `lib/features/dashboard/providers/dashboard_provider.dart` (tính toán hoàn toàn từ `TransactionProvider.transactions`: totalIncome, totalExpense, balance, recent transactions, 6-month chart)
- [x] **Dashboard UI**:
  - [x] `lib/features/dashboard/widgets/dashboard_header.dart` (chứa avatar mở Cài đặt & Logout)
  - [x] `lib/features/dashboard/widgets/balance_card.dart`
  - [x] `lib/features/dashboard/widgets/income_expense_cards.dart`
  - [x] `lib/features/dashboard/widgets/dashboard_chart_card.dart`
  - [x] `lib/features/dashboard/widgets/recent_transactions.dart`
  - [x] `lib/features/dashboard/screens/dashboard_screen.dart`
- [x] **Main Shell**:
  - [x] `lib/shared/widgets/app_bottom_navigation.dart` (thanh điều hướng Penny với nút + nổi)
  - [x] `lib/navigation/main_shell.dart` (kết nối DashboardScreen và TransactionListScreen)
- [x] **Checklist hoàn thành**: `flutter analyze` không lỗi, toàn bộ flow app hoạt động mượt mà.

---

### 🟢 GIAI ĐOẠN 5: SECURITY RULES, TESTS & LINT CLEANUP
> **Mục tiêu**: Kiểm tra bảo mật Firestore, viết Unit Tests với mocktail, đảm bảo code hoàn toàn sạch sẽ.

- [x] Kiểm tra lại `firestore.rules` (đảm bảo match đúng path và rule kiểm tra)
- [x] Unit Test `test/features/transactions/transaction_model_test.dart`
- [x] Unit Test `test/features/dashboard/dashboard_provider_test.dart`
- [x] Unit Test `test/features/auth/auth_provider_test.dart`
- [x] Unit Test `test/features/transactions/transaction_provider_test.dart`
- [x] Chạy `flutter test` đảm bảo pass 100% (14/14 tests)
- [x] Chạy `flutter analyze` đảm bảo không có cảnh báo/lỗi (0 errors, 0 warnings)

---

### ⚪ GIAI ĐOẠN 6: TÀI LIỆU BÁO CÁO & TEST CASES
> **Mục tiêu**: Cập nhật chi tiết 10 Test Cases bắt buộc và hoàn thiện khung báo cáo.

- [ ] Cập nhật `docs/test_cases.md` theo 10 kịch bản đề thi
- [ ] Hoàn thiện `docs/report.md` (kiến trúc, quyết định kỹ thuật, hướng dẫn cài đặt và chạy)
- [ ] Kiểm tra cấu trúc thư mục lần cuối
