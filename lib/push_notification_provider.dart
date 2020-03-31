import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  initNotificacions() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });
    _firebaseMessaging.configure(
      onMessage: (info) {
        print('==== On Message ====');
        print(info);
      },
      onLaunch: (info) {
        print('==== On Launch ====');
        print(info);
      },
      onResume: (info) {
        print('==== On Resume ====');
        print(info);
      },
    );
  }
}
