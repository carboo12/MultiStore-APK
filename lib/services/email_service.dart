import 'package:myapp/model/store_model.dart';
import 'dart:developer' as developer;

class EmailService {
  // IMPORTANT SECURITY NOTE:
  // Sending emails directly from a client-side application like Flutter is
  // highly insecure. It requires embedding your email credentials (username and
  // password) directly in the app's code, which can be easily extracted by
  // malicious users.
  //
  // The CORRECT and SECURE approach is to use a backend service.
  // For example, you can create a Cloud Function for Firebase that listens for
  // new store registrations in your database. This function can then securely
  // send the email from the server, without exposing any credentials in the app.
  //
  // The code below SIMULATES sending an email by printing the details to the
  // debug console. This should be replaced with a call to your backend service.

  Future<void> sendRegistrationEmail(Store store) async {
    const recipientEmail = 'wordwideallainoneprogramin@gmail.com';

    final subject = 'New Store Registration: ${store.name}';
    final body = '''
A new store has been registered with the following details:

Store Name: ${store.name}
Store Email: ${store.email}
Store Phone: ${store.phone}
Store Address: ${store.address}

License Plan: ${store.licensePlan}
License Key: ${store.licenseKey}
Registration Date: ${store.registrationDate}
Expiration Date: ${store.expirationDate}
''';

    developer.log('--- SIMULATING EMAIL ---', name: 'EmailService');
    developer.log('Recipient: $recipientEmail', name: 'EmailService');
    developer.log('Subject: $subject', name: 'EmailService');
    developer.log('Body:\n$body', name: 'EmailService');
    developer.log('--- END OF SIMULATED EMAIL ---', name: 'EmailService');

    // TODO: Replace this simulation with a call to a secure backend function.
    // For example, using Firebase Functions:
    // await FirebaseFunctions.instance.httpsCallable('sendRegistrationEmail').call({
    //   'storeData': store.toJson(), // You would need a toJson method in your model
    // });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
  }
}
