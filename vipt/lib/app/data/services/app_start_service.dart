import 'package:firebase_core/firebase_core.dart';
import 'package:vipt/app/data/services/data_service.dart';
import 'package:vipt/firebase_options.dart';

class AppStartService {
  AppStartService._privateConstructor();
  static final AppStartService instance = AppStartService._privateConstructor();

  Future<void> initService() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Khởi tạo DataService với lifecycle observer
    DataService.instance.initialize();
  }
}
