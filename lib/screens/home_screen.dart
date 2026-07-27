import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/custom_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _currentTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const List<String> days = [
      'Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'
    ];
    const List<String> months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];

    String dayName = days[date.weekday % 7];
    String monthName = months[date.month - 1];
    
    return "$dayName, ${date.day} $monthName ${date.year}";
  }

  String _formatTime(DateTime date) {
    String hours = date.hour.toString().padLeft(2, '0');
    String minutes = date.minute.toString().padLeft(2, '0');
    String seconds = date.second.toString().padLeft(2, '0');
    return "$hours.$minutes.$seconds WIB";
  }

  final String _danantaraLogoUrl = 'https://i.postimg.cc/3x7HCSMZ/Danantara-Indonesia.png';
  final String _plnLogoUrl = 'https://i.postimg.cc/yNdtv2L4/PLN-Logo.png';

  final Color primaryBlue = const Color(0xFF003D7A);
  final Color textGrey = const Color(0xFF666666);
  final Color borderGrey = const Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
              const SizedBox(height: 16),

              _buildDateTimeSection(),
              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
              const SizedBox(height: 24),

              _buildCriticalAlarm(),
              const SizedBox(height: 24),

              _buildStatusCards(),
              const SizedBox(height: 24),

              _buildRealtimeTrackingCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: _danantaraLogoUrl,
          height: 32,
          width: 130,
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          placeholder: (context, url) => const SizedBox(height: 32, width: 100),
          errorWidget: (context, url, error) => const Icon(Icons.business, size: 32),
        ),
        const Spacer(),
        CachedNetworkImage(
          imageUrl: _plnLogoUrl,
          height: 28,
          width: 70,
          fit: BoxFit.contain,
          alignment: Alignment.centerRight,
          placeholder: (context, url) => const SizedBox(height: 28, width: 60),
          errorWidget: (context, url, error) => const Icon(Icons.bolt, size: 28, color: Colors.yellow),
        ),
        const SizedBox(width: 12),
        Icon(Icons.notifications_none_outlined, color: primaryBlue, size: 28),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _formatDate(_currentTime),
          style: TextStyle(fontSize: 13, color: textGrey),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Koper CCTV',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            Text(
              _formatTime(_currentTime),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCriticalAlarm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        border: const Border(
          left: BorderSide(color: Color(0xFFC62828), width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFC62828), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ALARM KRITIS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC62828),
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 12, color: Color(0xFFC62828), height: 1.4),
                    children: [
                      TextSpan(text: 'KP '),
                      TextSpan(text: 'WG2-351', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' trip,\nsegera ambil\ntindakan pada titik\nKP tersebut!'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB71C1C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 0,
            ),
            child: const Text(
              'NAVIGASI RUTE',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCards() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderGrey),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _buildStatusItem(
                icon: Icons.router_outlined,
                iconColor: primaryBlue,
                bgColor: const Color(0xFFE3F2FD),
                label: 'PERANGKAT',
                value: '12',
                valueColor: primaryBlue,
              ),
            ),
            VerticalDivider(width: 1, thickness: 1, color: borderGrey),
            Expanded(
              child: _buildStatusItem(
                icon: Icons.check_circle_outline,
                iconColor: Colors.green.shade700,
                bgColor: const Color(0xFFE8F5E9),
                label: 'AKTIF',
                value: '10',
                valueColor: Colors.green.shade700,
              ),
            ),
            VerticalDivider(width: 1, thickness: 1, color: borderGrey),
            Expanded(
              child: _buildStatusItem(
                icon: Icons.error_outline,
                iconColor: const Color(0xFFC62828),
                bgColor: const Color(0xFFFFEBEE),
                label: 'ATENSI',
                value: '2',
                valueColor: const Color(0xFFC62828),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textGrey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }

  Widget _buildRealtimeTrackingCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderGrey),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lacak Real-time',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Peta sebaran perangkat aktif di lapangan',
                        style: TextStyle(fontSize: 13, color: textGrey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.map_outlined, color: primaryBlue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, thickness: 1, color: borderGrey),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF808000),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'LIVE UPDATE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B8E23),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward, color: primaryBlue, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
