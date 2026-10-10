# 🚀 Antigravity Auto-Proceed Enabler

> Giải pháp sửa lỗi triệt để cho vấn đề **Google Antigravity vẫn bắt duyệt lệnh bằng tay** dù đã bật *"Always Proceed"* trong Settings.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-green.svg)]()

---

## 📌 Vấn đề là gì? (The Problem)

Trong quá trình sử dụng Google Antigravity, nhiều người dùng gặp tình trạng: **Dù đã chọn `Always Proceed` trong cài đặt, mỗi khi AI thực thi lệnh Terminal (npm, git, build, test...), hệ thống vẫn hiển thị prompt yêu cầu nhấn phím `1` hoặc bấm Duyệt (Approve) bằng tay.**

### 🔍 Nguyên nhân kỹ thuật:
1. **Xung đột cấu hình cấp Project:** Antigravity ưu tiên cấu hình riêng của Project hơn cấu hình Global. Ngay cả khi bạn bật ở giao diện ngoài, các file project trong `~/.gemini/config/projects/` vẫn lưu cứng:
   ```json
   "autoExecutionPolicy": "CASCADE_COMMANDS_AUTO_EXECUTION_OFF"
   ```
2. **Giá trị Enum thực tế của Antigravity:** Trong lõi ngôn ngữ (`language_server`), giá trị kích hoạt chế độ tự động chạy hoàn toàn không hỏi lại là:
   ```json
   "autoExecutionPolicy": "CASCADE_COMMANDS_AUTO_EXECUTION_EAGER"
   ```

---

## ⚠️ Lưu ý an toàn (Tại sao KHÔNG NÊN dán đè file `config.json` của người khác?)

Nhiều người nghĩ chỉ cần copy file `config.json` từ máy người khác dán đè vào là xong. **Điều này rất nguy hiểm:**
* File `config.json` thật chứa thông tin nhạy cảm: **Username máy tính, đường dẫn private, hostname kết nối, code nhúng trong permissions**.
* Dán đè sẽ **xóa sạch toàn bộ danh sách Plugin** và các thiết lập riêng mà bạn đã cài đặt trước đó.

👉 **Repo này cung cấp các kịch bản Patch thông minh:** Chỉ đọc file của bạn, sửa đúng 1 dòng `autoExecutionPolicy`, giữ nguyên 100% dữ liệu khác và tự động tạo bản sao lưu an toàn!

---

## ⚡ Hướng dẫn cài đặt & Sử dụng (Quick Start)

### Cách 1: Chạy 1-Click trên Windows (Khuyên dùng)
1. Tải repository này về máy (Bấm **Code** -> **Download ZIP** rồi giải nén).
2. Click đúp vào file **`patch.bat`**.
3. Khởi động lại (Restart/Reload) ứng dụng Antigravity. Xong!

---

### Cách 2: Dùng PowerShell (Windows)
Mở PowerShell tại thư mục repo và chạy lệnh:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\patch_config.ps1
```

---

### Cách 3: Dùng Python (Hỗ trợ cả Windows, macOS, Linux)
Nếu máy bạn có cài Python 3:
```bash
python scripts/patch_config.py
```

---

### Cách 4: Sửa thủ công bằng tay (Manual)
1. Mở file cấu hình Antigravity:
   * **Windows:** `%USERPROFILE%\.gemini\config\config.json`
   * **macOS / Linux:** `~/.gemini/config/config.json`
2. Tìm đến trường `autoExecutionPolicy` trong `userSettings` và đổi thành:
   ```json
   "autoExecutionPolicy": "CASCADE_COMMANDS_AUTO_EXECUTION_EAGER"
   ```
3. Nếu bạn đang mở các project cụ thể, mở thêm các file `.json` trong thư mục `projects/` cùng cấp và đổi tương tự.

---

## 🔄 Cách hoàn tác (Restore / Revert)

Nếu sau này bạn muốn quay lại chế độ duyệt lệnh thủ công từng bước:
* **Trên Windows:** Click đúp vào file **`restore.bat`** (hoặc chạy `.\scripts\restore_config.ps1`).
* **Bằng Python:** Chạy lệnh:
  ```bash
  python scripts/patch_config.py --revert
  ```

---

## 🎁 Công cụ phụ trợ: Auto-Accept Keyboard Tool

Ngoài việc sửa config, thư mục `tools/` cung cấp công cụ tự động bấm phím `1` độc lập (hữu ích khi Antigravity gặp các prompt an toàn đặc biệt):

* **Python (`tools/auto_accept_key1.py`):**
  * Viết bằng thư viện chuẩn Windows API (`ctypes`), không cần cài thêm `pip`.
  * Nhấn **F8** để Bật / Tắt (có tiếng Beep phân biệt).
  * Chỉ bấm `1` khi cửa sổ `Antigravity` đang Active.
  * Chạy bằng:
    ```bash
    python tools/auto_accept_key1.py
    ```

* **AutoHotkey v2 (`tools/auto_accept_key1.ahk`):**
  * Dành cho người dùng quen xài AutoHotkey. Nhấn **F8** để bật/tắt.

---

## 📁 Cấu trúc Repository

```text
antigravity-auto-proceed/
├── patch.bat                  # Click đúp để patch trên Windows
├── restore.bat                # Click đúp để hoàn tác về mặc định
├── README.md                  # Tài liệu hướng dẫn
├── LICENSE                    # MIT License
├── .gitignore
├── scripts/
│   ├── patch_config.ps1       # Script PowerShell chính (Backup + Patch)
│   ├── restore_config.ps1     # Script PowerShell hoàn tác
│   └── patch_config.py        # Script Python đa nền tảng
├── templates/
│   └── config.template.json   # Template mẫu chuẩn (đã xóa dữ liệu cá nhân)
└── tools/
    ├── auto_accept_key1.py    # Tool auto bấm phím 1 bằng Python (F8 toggle)
    └── auto_accept_key1.ahk   # Tool auto bấm phím 1 bằng AutoHotkey
```

---

## 📄 License
Phát hành theo giấy phép [MIT License](LICENSE). Bạn hoàn toàn có thể tự do sử dụng, chỉnh sửa và chia sẻ!
