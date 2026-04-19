import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Initialize the plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // Pastikan binding terinisialisasi sebelum memanggil platform channel
  WidgetsFlutterBinding.ensureInitialized();

  // Konfigurasi icon untuk notifikasi Android (gunakan mipmap/ic_launcher bawaan)
  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Inisialisasi flutter_local_notifications_plugin
  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Notification App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const NotificationPage(),
    );
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  // Request permission untuk Android 13+
  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> _showNotification() async {
    final DateTime now = DateTime.now();

    // Format waktu manual agar menjadi HH:MM:SS
    final String hour = now.hour.toString().padLeft(2, '0');
    final String minute = now.minute.toString().padLeft(2, '0');
    final String second = now.second.toString().padLeft(2, '0');

    final String timeStr = "$hour:$minute:$second";

    // Konfigurasi detail notifikasi
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'notification_channel_id',
          'Notification Channel',
          channelDescription: 'Channel for local notification',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    // Menampilkan notifikasi
    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: 'Waktu Ditekan',
      body: 'Anda menekan tombol pada waktu $timeStr',
      notificationDetails: notificationDetails,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Notification App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Text(
          'Tekan FAB untuk membuat notifikasi.',
          style: TextStyle(fontSize: 16),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNotification,
        tooltip: 'Notifikasi',
        child: const Icon(Icons.notifications_active),
      ),
    );
  }
}
