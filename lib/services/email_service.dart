import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:myapp/model/store_model.dart';
import 'dart:developer' as developer;

class EmailService {
  // --- IMPORTANTE: LEER ESTA NOTA DE SEGURIDAD ---
  //
  // Enviar correos directamente desde una aplicación móvil como Flutter es
  // ALTAMENTE INSEGURO. Requiere que incrustes las credenciales de tu correo
  // (usuario y contraseña) directamente en el código de la aplicación.
  //
  // Un atacante puede descompilar tu app y robar estas credenciales,
  // obteniendo acceso completo a tu cuenta de correo para enviar spam,
  // leer tus correos privados o realizar otras acciones maliciosas.
  //
  // LA FORMA CORRECTA Y SEGURA es usar un servicio de backend (como Firebase
  // Cloud Functions o tu propio servidor). La app notifica al backend, y el
  // backend, que es un entorno seguro, se encarga de enviar el correo.
  //
  // El siguiente código es solo para fines de DEMOSTRACIÓN y DESARROLLO.
  // NUNCA uses este método en una aplicación de producción.
  //
  // --- FIN DE LA NOTA DE SEGURIDAD ---

  Future<void> sendRegistrationEmail(Store store) async {
    // --- ¡NO USAR EN PRODUCCIÓN! ---
    // Reemplaza con tus propias credenciales de Gmail.
    // Es posible que necesites generar una "Contraseña de aplicación" en tu
    // cuenta de Google si tienes la autenticación de 2 factores activada.
    final String username = 'tu_correo@gmail.com';
    final String password = 'tu_contraseña_de_aplicacion'; // ¡NO tu contraseña normal!

    // Configura el servidor SMTP de Gmail.
    final smtpServer = gmail(username, password);

    // Dirección de correo a la que se enviará la notificación.
    const recipientEmail = 'wordwideallainoneprogramin@gmail.com';

    // Crea el mensaje.
    final message = Message()
      ..from = Address(username, 'Latienda Express Notifier')
      ..recipients.add(recipientEmail)
      ..subject = 'New Store Registration: ${store.name}'
      ..text = '''
A new store has been registered with the following details:

Store Name: ${store.name}
Store Email: ${store.email}
Store Phone: ${store.phone}
Store Address: ${store.address}

License Plan: ${store.licensePlan}
Number of Users: ${store.numberOfUsers}
License Key: ${store.licenseKey}
Registration Date: ${store.registrationDate}
Expiration Date: ${store.expirationDate}
''';

    try {
      developer.log('Attempting to send email...', name: 'EmailService');
      final sendReport = await send(message, smtpServer);
      developer.log('Message sent: ' + sendReport.toString(), name: 'EmailService');
    } on MailerException catch (e) {
      developer.log('Message not sent. \n' + e.toString(), name: 'EmailService');
      // También puedes relanzar el error si quieres que la UI reaccione.
      // throw e;
    }
  }
}
