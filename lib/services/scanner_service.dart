import 'dart:async';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:flutter_datawedge/models/scan_result.dart';

/// Un servicio para abstraer la comunicación con el hardware de escaneo
/// a través de DataWedge en dispositivos Zebra.
class ScannerService {
  late final FlutterDataWedge _dataWedge;
  StreamSubscription<ScanResult>? _scanSubscription;

  // StreamController para emitir los datos escaneados como un String.
  final _scanResultController = StreamController<String>.broadcast();

  /// Stream público para que los widgets puedan escuchar los resultados del escaneo.
  Stream<String> get scanResultStream => _scanResultController.stream;

  ScannerService() {
    _dataWedge = FlutterDataWedge(profileName: 'LatiendaExpressProfile');
  }

  /// Inicializa el servicio, crea y configura el perfil de DataWedge y
  /// comienza a escuchar los escaneos.
  Future<void> init() async {
    try {
      // 1. Crea un perfil para la app para no interferir con otras aplicaciones.
      await _dataWedge.createProfile();

      // 2. Escucha los resultados del escaneo.
      // El paquete configura automáticamente el perfil para enviar los datos a la app.
      _scanSubscription = _dataWedge.onScanResult.listen((result) {
        if (result.data.isNotEmpty) {
          _scanResultController.add(result.data);
        }
      });
    } catch (e) {
      // Maneja cualquier error durante la inicialización.
      _scanResultController.addError('Error al inicializar el escáner: $e');
    }
  }

  /// Activa o desactiva el gatillo del escáner por software.
  Future<void> triggerScan(bool enable) async {
    await _dataWedge.triggerScan(enable);
  }

  /// Libera los recursos del servicio. Debe ser llamado en el dispose del widget.
  void dispose() {
    _scanSubscription?.cancel();
    _scanResultController.close();
  }
}
