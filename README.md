# flutter_1

## 1. How To Start Application

Run this instruction in terminal:
```bash
flutter pub get
flutter run 
```
## 2. Architecture
this application its use Clean Architecutre
- Domain Layer -> entites
- Data Layer -> Models, implement repository, and data source
- Presentation layer -> UI Widget and Provider

## 3. State Management I Use
Riverpod (flutter_riverpod)
Why?
-Keamanan Compile Time: Mencegah error ProviderNotFoundException yang sering terjadi pada Provider konvensional.

-Isolasi Logika: StateNotifier memungkinkan pemisahan logika async (loading, error, empty) secara bersih di luar Widget.

-Skalabilitas: Memudahkan injeksi dependensi (Dependency Injection) untuk SharedPreferences dan LocalDataSource secara global tanpa mengotori Widget Tree.

## 4. Keterbatasan dan Trade-off
Simulasi Pagination: Karena aplikasi menggunakan data JSON lokal (array statis), pagination disimulasikan menggunakan List.skip().take() dan Future.delayed. Di skenario produksi dengan REST API nyata, ini akan diganti dengan parameter page dan limit di URL request.

Penyimpanan Shared Preferences: Untuk memenuhi syarat zero-config tanpa setup tambahan, data favorite disimpan menggunakan SharedPreferences (berupa List of String IDs). Pada aplikasi berskala lebih besar, penyimpanan relasional lokal seperti SQLite/Drift akan lebih direkomendasikan daripada Key-Value store.

## 5. Estimition to Finish
Estimasi waktu pengerjaan keseluruhan: +-6 Jam.

## 6. Penggunaan AI Tools
Tool yang digunakan: Google Gemini.

Bagian yang dibantu:

Menghasilkan struktur awal direktori Clean Architecture.

Menghasilkan mock data JSON (20 item film beserta placeholder gambar).

Memberikan panduan sinkronisasi state persisten antara SharedPreferences dan StateNotifierProvider untuk fitur Favorite.

Membantu penyusunan sintaks mocktail untuk Unit Testing pada Repository.