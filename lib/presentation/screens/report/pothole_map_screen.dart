import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

import '../../../data/models/models.dart';
import '../../../data/providers/activity_map_provider.dart';

class PotholeMapScreen extends ConsumerStatefulWidget {
  final PotholeModel? pothole;

  const PotholeMapScreen({
    super.key,
    this.pothole,
  });

  @override
  ConsumerState<PotholeMapScreen> createState() => _PotholeMapScreenState();
}

class _PotholeMapScreenState extends ConsumerState<PotholeMapScreen> {
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};
  bool _isInit = true;
  
  @override
  void initState() {
    super.initState();
    if (widget.pothole != null) {
      _loadReportMarkers();
    } else {
      _centerOnUser();
    }
  }

  Future<void> _centerOnUser() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        _controller.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 14),
        );
      }
    } catch (e) {
      // Location disabled or denied, ignore
    }
  }

  void _loadReportMarkers() {
    final pothole = widget.pothole!;
    _markers.clear();

    // 1. Add markers from images
    if (pothole.potholeImages != null && pothole.potholeImages!.isNotEmpty) {
      for (int i = 0; i < pothole.potholeImages!.length; i++) {
        final img = pothole.potholeImages![i];
        if (img.latitude != null && img.longitude != null) {
          _markers.add(
            Marker(
              markerId: MarkerId('img_$i'),
              position: LatLng(img.latitude!, img.longitude!),
              infoWindow: InfoWindow(title: 'Location ${i + 1}'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),
          );
        }
      }
    }

    // 2. Fallback to main location if no image markers added
    if (_markers.isEmpty && pothole.latitude != null && pothole.longitude != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('main'),
          position: LatLng(pothole.latitude!, pothole.longitude!),
          infoWindow: InfoWindow(title: pothole.location ?? 'Pothole Location'),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }
  }

  void _loadActivityMarkers(ActivityMapData data) {
    _markers.clear();
    
    // In Progress - Orange
    for (var p in data.inProgress) {
      _markers.add(Marker(
        markerId: MarkerId('prog_${p.lat}_${p.lng}'),
        position: LatLng(p.lat, p.lng),
        infoWindow: InfoWindow(title: 'In Progress: ${p.roadName}', snippet: p.divisionName),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));
    }

    // Rejected - Red
    for (var p in data.rejected) {
      _markers.add(Marker(
        markerId: MarkerId('rej_${p.lat}_${p.lng}'),
        position: LatLng(p.lat, p.lng),
        infoWindow: InfoWindow(title: 'Rejected: ${p.roadName}', snippet: p.divisionName),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }

    // Completed - Green
    for (var p in data.completed) {
      _markers.add(Marker(
        markerId: MarkerId('comp_${p.lat}_${p.lng}'),
        position: LatLng(p.lat, p.lng),
        infoWindow: InfoWindow(title: 'Completed: ${p.roadName}', snippet: p.divisionName),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }
  }

  Future<void> _openGoogleNavigation(double lat, double lng) async {
    final url = 'google.navigation:q=$lat,$lng';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activityAsync = ref.watch(activityMapProvider);
    
    // Set initial position
    LatLng initialPos = const LatLng(26.1158, 91.7086); // Guwahati default
    if (widget.pothole != null) {
      final lat = widget.pothole!.latitude ?? widget.pothole!.potholeImages?.firstOrNull?.latitude;
      final lng = widget.pothole!.longitude ?? widget.pothole!.potholeImages?.firstOrNull?.longitude;
      if (lat != null && lng != null) initialPos = LatLng(lat, lng);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D9A7E),
        foregroundColor: Colors.white,
        title: Text(widget.pothole != null ? 'Report Map' : 'Pothole Activity Map', 
                   style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          if (widget.pothole == null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.refresh(activityMapProvider),
            ),
        ],
      ),
      body: SafeArea(child: widget.pothole != null 
          ? _buildMap(initialPos) 
          : activityAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (data) {
                if (_isInit) {
                  _loadActivityMarkers(data);
                  _isInit = false;
                }
                return _buildMap(initialPos);
              },
            )),
    );
  }

  Widget _buildMap(LatLng initialPos) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialPos,
            zoom: widget.pothole != null ? 15 : 12,
          ),
          markers: _markers,
          onMapCreated: (controller) => _controller = controller,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapToolbarEnabled: false,
        ),
        
        if (widget.pothole != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _buildLocationItems(),
                    ),
                  ),
                ),
              ),
            ),
          )
        else
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 16, 10, 24), // Added padding for bottom area
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -2)),
                ],
                border: const Border(top: BorderSide(color: Colors.black12, width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLegendItem('In Progress', const Color(0xFFFFE0B2), Colors.orange),
                  _buildLegendItem('Rejected', const Color(0xFFFFCDD2), Colors.red),
                  _buildLegendItem('Completed', const Color(0xFFC8E6C9), Colors.green),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color bgColor, Color dotColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: dotColor.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.black87.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLocationItems() {
    final List<Widget> items = [];
    final pothole = widget.pothole!;
    
    if (pothole.potholeImages != null && pothole.potholeImages!.isNotEmpty) {
      for (int i = 0; i < pothole.potholeImages!.length; i++) {
        final img = pothole.potholeImages![i];
        if (img.latitude != null && img.longitude != null) {
          items.add(_buildLocationTile(i + 1, img.latitude!, img.longitude!));
          if (i < pothole.potholeImages!.length - 1) {
            items.add(const Divider(height: 1, indent: 60));
          }
        }
      }
    } else if (pothole.latitude != null && pothole.longitude != null) {
      items.add(_buildLocationTile(1, pothole.latitude!, pothole.longitude!));
    }

    if (items.isEmpty) {
      items.add(const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Coordinates unavailable for this report', style: TextStyle(color: Colors.grey)),
      ));
    }

    return items;
  }

  Widget _buildLocationTile(int index, double lat, double lng) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF3D9A7E),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text('Lat: ', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    Text(lat.toStringAsFixed(6), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('Lng: ', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    Text(lng.toStringAsFixed(6), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _openGoogleNavigation(lat, lng),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Get Direction',
              style: TextStyle(
                color: Color(0xFF1976D2),
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
