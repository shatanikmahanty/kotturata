import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kotturata/blocs/artist_bloc.dart';
import 'package:kotturata/blocs/theme_bloc.dart';
import 'package:kotturata/pages/artist_page.dart';
import 'package:kotturata/utils/next_screen.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = new TextEditingController();
  bool isSearching = false;
  String searchQuery = '';
  var formKey = GlobalKey<FormState>();

  final List titles = [
    /*'Categories', 'Bookmark',*/
    'Dark Theme',
  ];
  final List icons = [Icons.wb_sunny];

  bool isListView = false;

  String getResultString(int count) {
    String resultStr;
    if (count < 2) {
      resultStr = "Result";
    } else {
      resultStr = "Results";
    }

    return resultStr;
  }

  @override
  Widget build(BuildContext context) {
    final ArtistsDataBloc adb = Provider.of<ArtistsDataBloc>(context);
    final ThemeBloc tb = Provider.of<ThemeBloc>(context);

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    var _scaffoldKey = new GlobalKey<ScaffoldState>();
    Widget buildHome() {
      return Container(
        height: h * 0.9,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: new AssetImage("assets/background.jpg"),
                fit: BoxFit.cover)),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Text(
              "Kotturata",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          drawer: getDrawer(tb),
          backgroundColor: Colors.transparent,
          body: Container(
            width: w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      autofocus: false,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.withOpacity(0.5),
                        filled: true,
                        hintText: 'Search for artists',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: searchQuery.trim().length > 0
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {
                                    searchQuery = '';
                                    isSearching = false;
                                  });
                                },
                              )
                            : Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                      ),
                      controller: searchController,
                      onChanged: (String value) {
                        adb.filterData(value.toLowerCase());
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: searchQuery.length != 0
                      ? Row(
                          children: [
                            Text(
                              "${adb.searchData.length} ${getResultString(adb.searchData.length)}", //Search Result string
                              style: TextStyle(
                                  fontSize: 23,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white),
                            ),
                            Spacer(),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                  icon: isListView
                                      ? Icon(Icons.list)
                                      : Icon(Icons.grid_view),
                                  onPressed: () {
                                    setState(() {
                                      isListView = !isListView;
                                    });
                                  }),
                            )
                          ],
                        )
                      : Row(
                          children: [
                            Text(
                              "All Artists",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.8),
                            ),
                            Spacer(),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                  icon: isListView
                                      ? Icon(Icons.list)
                                      : Icon(Icons.grid_view),
                                  onPressed: () {
                                    setState(() {
                                      isListView = !isListView;
                                    });
                                  }),
                            )
                          ],
                        ),
                ),
                Expanded(
                    child: adb.artistsData.length == 0
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : searchQuery.length != 0
                            ? searchView(adb, w)
                            : normalView(adb, w)),
              ],
            ),
          ),
        ),
      );
    }

    return buildHome();
  }

  Widget normalView(ArtistsDataBloc adb, w) {
    if (isListView) {
      return normalListView(adb, w);
    } else {
      return normalGridView(adb, w);
    }
  }

  Widget searchView(ArtistsDataBloc adb, w) {
    if (isListView) {
      return searchedListView(adb, w);
    } else {
      return searchedGridView(adb, w);
    }
  }

  Widget searchedListView(ArtistsDataBloc adb, w) {
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: adb.searchData.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              nextScreen(
                  context,
                  ArtistPage(
                    artistName: adb.searchData[index]['name'],
                    artistImageUrl: adb.searchData[index]['image_url'],
                    artistTimestamp: adb.searchData[index]['timestamp'],
                    tag: '$index',
                  ));
            },
            child: Hero(
              tag: '$index',
              child: Card(
                elevation: 10,
                color: Colors.black.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: Colors.transparent,
                child: Container(
                  width: w - 30,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          Text(
                            '${index + 1}.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 25,),
                          Text(
                            adb.searchData[index]['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget normalListView(ArtistsDataBloc adb, w) {
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        itemCount: adb.artistsData.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              nextScreen(
                  context,
                  ArtistPage(
                    artistName: adb.artistsData[index]['name'],
                    artistImageUrl: adb.artistsData[index]['image_url'],
                    artistTimestamp: adb.artistsData[index]['timestamp'],
                    tag: '$index',
                  ));
            },
            child: Hero(
              tag: '$index',
              child: Card(
                elevation: 10,
                color: Colors.black.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: Colors.transparent,
                child: Container(
                  width: w - 30,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          Text(
                            '${index + 1}.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 25,),
                          Text(
                            adb.artistsData[index]['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget searchedGridView(ArtistsDataBloc adb, w) {
    return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        itemCount: adb.searchData.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              nextScreen(
                  context,
                  ArtistPage(
                    artistName: adb.searchData[index]['name'],
                    artistImageUrl: adb.searchData[index]['image_url'],
                    artistTimestamp: adb.searchData[index]['timestamp'],
                    tag: '$index',
                  ));
            },
            child: Hero(
              tag: '$index',
              child: Card(
                elevation: 25,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                shadowColor: Colors.transparent,
                child: Container(
                  width: w - 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          adb.searchData[index]['image_url'],
                        ),
                        fit: BoxFit.cover),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        adb.searchData[index]['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget normalGridView(ArtistsDataBloc adb, w) {
    return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        itemCount: adb.artistsData.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              nextScreen(
                  context,
                  ArtistPage(
                    artistName: adb.artistsData[index]['name'],
                    artistImageUrl: adb.artistsData[index]['image_url'],
                    artistTimestamp: adb.artistsData[index]['timestamp'],
                    tag: '$index',
                  ));
            },
            child: Hero(
              tag: '$index',
              child: Card(
                elevation: 25,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                shadowColor: Colors.transparent,
                child: Container(
                  width: w - 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          adb.artistsData[index]['image_url'],
                        ),
                        fit: BoxFit.cover),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        adb.artistsData[index]['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget getDrawer(ThemeBloc tb) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                color: Colors.black45,
                padding: EdgeInsets.all(15),
                height: 140,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[400],
                        backgroundImage: AssetImage("assets/k.png"),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Kotturata",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            SizedBox(height: 10),
            Container(
              height: 350,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  title: Row(
                    children: [
                      Text(
                        titles[0],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      Spacer(),
                      Switch(
                        activeColor: Colors.white,
                        value: tb.darkTheme,
                        onChanged: (value) async {
                          // setState(() {
                          tb.darkTheme = value;
                          // }); //Storing notification status value to shared preferences.
                        },
                      ),
                    ],
                  ),
                  leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        !tb.darkTheme
                            ? Icons.wb_sunny
                            : Icons.nights_stay_rounded,
                        color: Colors.black87,
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
