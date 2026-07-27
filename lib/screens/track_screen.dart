import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/custom_header.dart';

class KoperDevice {
  final String id;
  final String team;
  final double lat;
  final double lng;
  final bool isOnline;
  final bool isCamActive;
  final String lastUpdate;
  final Color statusColor;

  KoperDevice({
    required this.id,
    required this.team,
    required this.lat,
    required this.lng,
    required this.isOnline,
    required this.isCamActive,
    required this.lastUpdate,
    required this.statusColor,
  });
}

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final MapController _mapController = MapController();
  KoperDevice? _selectedDevice;

  LatLng? _currentPosition;
  bool _isLoadingLocation = false;
  final Color primaryBlue = const Color(0xFF003D7A);

  final List<KoperDevice> _devices = [
    KoperDevice(
      id: 'KOPER01',
      team: 'UP2DJTG-DCC1-HAR KP 1',
      lat: -6.2088,
      lng: 106.8456,
      isOnline: true,
      isCamActive: true,
      lastUpdate: '10s ago',
      statusColor: Colors.yellow.shade700,
    ),
    KoperDevice(
      id: 'KOPER02',
      team: 'UP2DJTG-DCC2-HAR KP 2',
      lat: -6.2050,
      lng: 106.8400,
      isOnline: true,
      isCamActive: false,
      lastUpdate: '2m ago',
      statusColor: Colors.red.shade700,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });

      if (_currentPosition != null) {
        _mapController.move(_currentPosition!, 15.0);
      }
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      debugPrint("Gagal mendapatkan lokasi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: CustomHeader(),
            ),
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentPosition ?? LatLng(_devices[0].lat, _devices[0].lng),
                      initialZoom: 14.0,
                      minZoom: 4.0,
                      maxZoom: 18.0,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                      onTap: (_, __) {
                        setState(() {
                          _selectedDevice = null;
                        });
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.kopercctv',
                        maxZoom: 19,
                      ),
                      MarkerLayer(
                        markers: [
                          ..._devices.map((device) => _buildMarker(device)),
                          if (_currentPosition != null)
                            Marker(
                              point: _currentPosition!,
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.blueAccent,
                                size: 30,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: _buildSearchBar(),
                  ),
                  Positioned(
                    bottom: _selectedDevice != null ? 280 : 24,
                    right: 16,
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.3),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _getUserLocation,
                        child: Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          child: _isLoadingLocation
                              ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: primaryBlue,
                            ),
                          )
                              : Icon(
                            Icons.my_location,
                            color: primaryBlue,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_selectedDevice != null)
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: _buildDetailCard(_selectedDevice!),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Marker _buildMarker(KoperDevice device) {
    bool isSelected = _selectedDevice?.id == device.id;
    return Marker(
      point: LatLng(device.lat, device.lng),
      width: 50,
      height: 50,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDevice = device;
            _mapController.move(LatLng(device.lat, device.lng), 15.0);
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? primaryBlue : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                Icons.supervised_user_circle,
                color: isSelected ? Colors.white : primaryBlue,
                size: 24,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: device.statusColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari tim atau id perangkat koper',
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey.shade600),
          suffixIcon: Icon(Icons.mic_none, color: Colors.grey.shade600),
        ),
      ),
    );
  }

  Widget _buildDetailCard(KoperDevice device) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.id,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'TIM: ${device.team}',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDevice = null;
                  });
                },
                child: const Icon(Icons.close, size: 20, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: primaryBlue),
                    const SizedBox(width: 4),
                    Text('Online', style: TextStyle(fontSize: 12, color: primaryBlue, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade500,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.videocam_outlined, size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                    const Text('Cam Active', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.sync, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text('Terakhir Update', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(device.lastUpdate, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.gps_fixed, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text('GPS', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${device.lat}, ${device.lng}',
                    style: const TextStyle(fontSize: 13, fontFamily: 'Courier', fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    elevation: 0,
                  ),
                  child: const Text('View Feed', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryBlue,
                    side: BorderSide(color: primaryBlue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text('Ping Device', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}