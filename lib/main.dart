import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kotturata/blocs/artist_bloc.dart';
import 'package:kotturata/models/download_progress.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  // final FirebaseOptions firebaseOptions = (Platform.isIOS || Platform.isMacOS)
  //     ? const FirebaseOptions(
  //   appId: '1:159623150305:ios:4a213ef3dbd8997b',
  //   messagingSenderId: '221949796439',
  //   apiKey: 'AIzaSyBgayMJ0m9LU41lG690vUYCV-fFoek9aKA',
  //   projectId: 'kotturata-2425c',
  // ) : const FirebaseOptions(
  //   appId: '1:221949796439:android:89743784de2d7b8d728312',
  //   messagingSenderId: '221949796439',
  //   apiKey: 'AIzaSyBgayMJ0m9LU41lG690vUYCV-fFoek9aKA',
  //   projectId: 'kotturata-2425c',
  // );

  FirebaseApp app;
  if(Firebase.apps.length == 0)
  app = await Firebase.initializeApp();//name: 'kotturata', options: firebaseOptions);
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
//  ThemeBloc themeChangeProvider = new ThemeBloc();

  @override
  void initState() {
//    getCurrentAppTheme();
    super.initState();
  }

//  void getCurrentAppTheme() async {
//    themeChangeProvider.darkTheme =
//    await themeChangeProvider.darkThemePreference.getTheme();
//  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<DownloadProgressModel>(
            create: (context) => DownloadProgressModel(),
          ),
//          ChangeNotifierProvider<ThemeBloc>(
//            create: (_) {
//              return themeChangeProvider;
//            },
//          ),
         ChangeNotifierProvider<ArtistsDataBloc>(
           create: (context) => ArtistsDataBloc(),
         ),
//          ChangeNotifierProvider<PopularDataBloc>(
//            create: (context) => PopularDataBloc(),
//          ),
//          ChangeNotifierProvider<RecentDataBloc>(
//            create: (context) => RecentDataBloc(),
//          ),
//          ChangeNotifierProvider<RecommandedDataBloc>(
//            create: (context) => RecommandedDataBloc(),
//          ),
//          ChangeNotifierProvider<UserBloc>(
//            create: (context) => UserBloc(),
//          ),
//          ChangeNotifierProvider<BookmarkBloc>(
//            create: (context) => BookmarkBloc(),
//          ),
//          ChangeNotifierProvider<CommentsBloc>(
//            create: (context) => CommentsBloc(),
//          ),
//          ChangeNotifierProvider<NotificationBloc>(
//            create: (context) => NotificationBloc(),
//          ),
//          ChangeNotifierProvider<ProfileNotificationBloc>(
//            create: (context) => ProfileNotificationBloc(),
//          ),
//          ChangeNotifierProvider<InternetBloc>(
//            create: (context) => InternetBloc(),
//          ),
//          ChangeNotifierProvider<ViralDataBloc>(
//            create: (context) => ViralDataBloc(),
//          ),
//          ChangeNotifierProvider<ViralCommentsBloc>(
//            create: (context) => ViralCommentsBloc(),
//          ),
//          ChangeNotifierProvider<CategoryBloc>(
//            create: (context) => CategoryBloc(),
//          ),
//          ChangeNotifierProvider<UserPostsBloc>(
//            create: (context) => UserPostsBloc(),
//          ),
//          ChangeNotifierProvider<UserSearchBloc>(
//            create: (context) => UserSearchBloc(),
//          ),
//          ChangeNotifierProvider<PostsCommentsBloc>(
//            create: (context) => PostsCommentsBloc(),
//          ),
        ],
//        child: Consumer<ThemeBloc>(
//          builder: (BuildContext context, value, Widget child) {
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
//                theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            home: MyHomePage()));
//          },
//        ));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
