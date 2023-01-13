import '../../main.dart';
import '../service/firebase_service.dart';
import '../service/notification_service.dart';
import '../utilities/progress_dialog_utils.dart';

void setUp() {
  getIt.registerSingleton<CustomDialogs>(CustomDialogs());
  getIt.registerSingleton<FirebaseService>(FirebaseService());
  getIt.registerSingleton<NotificationService>(NotificationService());
}
