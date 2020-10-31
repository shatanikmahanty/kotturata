import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kotturata/blocs/artist_bloc.dart';
import 'package:kotturata/models/download_progress.dart';
import 'package:kotturata/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'blocs/theme_bloc.dart';
import 'pages/home.dart';

import 'package:rxdart/subjects.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

const MethodChannel platform =
MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  // final FirebaseOptions firebaseOptions = (Platform.isIOS || Platform.isMacOS)
  //     ? const FirebaseOptions(
  //   appId: '1:159623150305:ios:4a213ef3dbd8997b',
  //   messagingSenderId: '221949796439',
  //   apiKey: 'AIzaSyBgayMJ0m9LU41lG690vUYCV-fFoek9aKA',
  //   projectId: 'kotturata-2425c',
  // )
  // : const FirebaseOptions(
  //   appId: '1:221949796439:android:89743784de2d7b8d728312',
  //   messagingSenderId: '221949796439',
  //   apiKey: 'AIzaSyBgayMJ0m9LU41lG690vUYCV-fFoek9aKA',
  //   projectId: 'kotturata-2425c',
  // );

  // final NotificationAppLaunchDetails notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  const MacOSInitializationSettings initializationSettingsMacOS =
  MacOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false);
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        selectNotificationSubject.add(payload);
      });

  // FirebaseApp app;
  if (Firebase.apps.length == 0) {
    // app =
    await Firebase.initializeApp();
  }
  //name: 'kotturata', options: firebaseOptions);
  // final FirebaseStorage storage = FirebaseStorage(
  //     app: app, storageBucket: 'gs://kotturata-2425c.appspot.com');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeBloc themeChangeProvider = new ThemeBloc();

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<DownloadProgressModel>(
            create: (context) => DownloadProgressModel(),
          ),
          ChangeNotifierProvider<ThemeBloc>(
            create: (_) {
              return themeChangeProvider;
            },
          ),
          ChangeNotifierProvider<ArtistsDataBloc>(
            create: (context) => ArtistsDataBloc(),
          ),
        ],
        child: Consumer<ThemeBloc>(
          builder: (BuildContext context, value, Widget child) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
               theme: Styles.themeData(themeChangeProvider.darkTheme, context),
                home: MyHomePage());
          },
        ));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
