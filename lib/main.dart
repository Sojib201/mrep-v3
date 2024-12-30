// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mrap_v03/Pages/loginPage.dart';

import 'package:mrap_v03/Pages/splash_screen.dart';
import 'package:mrap_v03/local_storage/hive_data_model.dart';
import 'package:mrap_v03/service/hive_adapter.dart';
import 'package:mrap_v03/themes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

// String address = "";

var SameDeviceId;
// var appVersion = "v-20231207"; // BIOPHARMA
var appVersion = "v-20240117"; //IBNSINA
// var appVersion = "v-20240729"; //APEX PHARMA
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  var dir = await getApplicationDocumentsDirectory();
  // Hive.init(dir.path);

  await Hive.initFlutter(dir.path);

  Hive.registerAdapter(AddItemModelAdapter());
  Hive.registerAdapter(CustomerDataModelAdapter());
  Hive.registerAdapter(DcrGSPDataModelAdapter());
  Hive.registerAdapter(RxDcrDataModelAdapter());
  Hive.registerAdapter(MedicineListModelAdapter());
  Hive.registerAdapter(DcrDataModelAdapter());
  Hive.registerAdapter(NoticeListModelAdapter());
  await Hive.openBox("userInfo");

  await HiveAdapter().HiveAdapterbox();

  await initializeService();

  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('bn'),
          Locale('fr'),
          Locale('hi'),
        ],
        path: 'assets/language',
        fallbackLocale: const Locale('en'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black));
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: 'mRep_v03',
        theme: defaultTheme,
        home: SplashScreen(),
      ),
    );
  }
}
