import 'dart:async';

import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../core/map/map_config.dart';
import '../../../core/location/location_service.dart';
import '../../../core/location/coordinate_formatter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _locationService = LocationService();

  geo.Position? _position;
  bool _isLocating = false;
  String? _locationError;
  MapboxMap? _mapboxMap;

  Future<void> _locate() async {
    setState(() {
      _isLocating = true;
      _locationError = null;
    });

    try {
      final position = await _locationService.getCurrentPosition();

      if (!mounted) return;

      setState(() {
        _position = position;
        _viewport = CameraViewportState(
          center: Point(
            coordinates: Position(position.longitude, position.latitude),
          ),
          zoom: 14,
        );
      });

      await _mapboxMap?.location.updateSettings(
        LocationComponentSettings(enabled: true),
      );
    } on StateError catch (error) {
      if (!mounted) return;

      setState(() {
        _locationError = error.message;
      });
    } on TimeoutException {
      if (!mounted) return;

      setState(() {
        _locationError = 'Position introuvable pour le moment. Réessayez.';
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _locationError = 'Impossible de récupérer votre position.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLocating = false;
        });
      }
    }
  }

  ViewportState _viewport = CameraViewportState(
    center: Point(coordinates: Position(-4.49, 48.38)),
    zoom: 7,
  );

  Future<void> _changeZoom(double change) async {
    final map = _mapboxMap;

    if (map == null) return;

    final camera = await map.getCameraState();
    final zoom = (camera.zoom + change).clamp(0.0, 22.0).toDouble();

    await map.easeTo(
      CameraOptions(zoom: zoom),
      MapAnimationOptions(duration: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carte maritime')),
      body: MapWidget(
        onMapCreated: (map) {
          setState(() {
            _mapboxMap = map;
          });
        },
        styleUri: MapConfig.styleUrl,
        viewport: _viewport,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'zoom-in',
            onPressed: _mapboxMap == null ? null : () => _changeZoom(1),
            tooltip: 'Zoomer',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'my-location',
            onPressed: _isLocating || _mapboxMap == null ? null : _locate,
            tooltip: 'Ma position',
            child: _isLocating
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'zoom-out',
            onPressed: _mapboxMap == null ? null : () => _changeZoom(-1),
            tooltip: 'Dézoomer',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _isLocating
                ? 'Recherche de votre position…'
                : _locationError ??
                      (_position == null
                          ? 'Appuyez sur « Ma position » pour vous localiser.'
                          : 'Latitude : ${formatDms(_position!.latitude, isLatitude: true)}\n'
                                'Longitude : ${formatDms(_position!.longitude, isLatitude: false)}'),
          ),
        ),
      ),
    );
  }
}
