import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kotturata/blocs/theme_bloc.dart';
import 'package:kotturata/models/download_progress.dart';
import 'package:kotturata/utils/dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({
    Key key,
    @required this.artistName,
    @required this.artistImageUrl,
    @required this.tag,
    @required this.artistTimestamp,
  }) : super(key: key);

  final String artistName, artistImageUrl, artistTimestamp, tag;

  @override
  _ArtistPageState createState() => _ArtistPageState(
        this.artistName,
        this.artistImageUrl,
        this.tag,
        this.artistTimestamp,
      );
}

class _ArtistPageState extends State<ArtistPage> {
  TextEditingController searchController = new TextEditingController();
  bool isSearching = false;
  String searchQuery = '';
  var formKey = GlobalKey<FormState>();

  final String artistName, artistImageUrl, tag, artistTimestamp;

  List songs = [];

  // Future checkFileExists(String fileName) async {
  //   String dir;
  //   if (Platform.isIOS) {
  //     dir = (await getApplicationDocumentsDirectory()).path;
  //   } else if (Platform.isAndroid) {
  //     dir = await ExtStorage.getExternalStoragePublicDirectory(
  //         ExtStorage.DIRECTORY_DOWNLOADS);
  //   }
  //
  //   String fullPath = "$dir/$fileName";
  //   if (await File(fullPath).exists()) {
  //     return true;
  //   }
  //   return false;
  // }

  _ArtistPageState(
    this.artistName,
    this.artistImageUrl,
    this.tag,
    this.artistTimestamp,
  );

  bool isLoading = true;

  Future getSongs() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('songs')
        .where('artist_timestamp', isEqualTo: artistTimestamp)
        .get();
    var x = snap.docs;
    songs.clear();
    x.forEach((f) {
      songs.add(f);
      print(songs.length);
    });

    songs.sort((a, b) => a['position'].compareTo(b['position']));

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getSongs();
    super.initState();
  }


  Widget buildArtist(_scaffoldKey, double w, double h, ThemeBloc tb) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: Container(
          height: h,
          child: Stack(
            children: [
              Stack(children: [
                Hero(
                  tag: tag,
                  child: Container(
                    width: w,
                    height: 360,
                    child: CachedNetworkImage(
                      imageUrl: artistImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
                Positioned(
                    top: 30,
                    left: 10,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
                Positioned(
                  width: w,
                  bottom: 50,
                  child: Text(
                    artistName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                )
              ]),
              //CachedNetworkImageProvider(imageUrl),
              Positioned(
                top: 330,
                child: Container(
                  width: w,
                  height: h - 330,
                  decoration: BoxDecoration(
                    color: tb.darkTheme
                        ? Colors.grey[900] /*(0xFF151515)*/
                        : Colors.grey[50],
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30)),
                  ),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : songs.isEmpty
                          ? Center(
                              child: Text(
                                "No songs found for $artistName",
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          : ListView.builder(
                              itemCount: songs.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                        elevation: 10,
                                        color: tb.darkTheme
                                            ? Colors.white
                                            : Colors.black,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 3,
                                            color: Colors.blueGrey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        shadowColor: Colors.transparent,
                                        child: Container(
                                          width: w - 30,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 60,
                                                padding:
                                                    EdgeInsets.only(left: 5.0),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '${index + 1}.',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: tb.darkTheme
                                                        ? Colors.black
                                                        : Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 60,
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    songs[index]['name'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: tb.darkTheme
                                                          ? Colors.black
                                                          : Colors.white,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                height: 60,
                                                alignment: Alignment.center,
                                                child: ViewModelProvider<
                                                    DownloadProgressModel>.withConsumer(
                                                  viewModel: DownloadProgressModel(),
                                                  reuseExisting: true,
                                                  builder:
                                                      (context, model, child) =>
                                                          Stack(
                                                    children: <Widget>[
                                                      Center(
                                                        child: SizedBox(
                                                          width: 100,
                                                          height: 100,
                                                          child: model.downloadProgress ==
                                                                      null
                                                                  ? Center(
                                                                      child:
                                                                          CircularProgressIndicator())
                                                                  : model.downloadProgress <
                                                                          0
                                                                      ? IconButton(
                                                                          icon:
                                                                              Icon(
                                                                            Icons.file_download,
                                                                            color: tb.darkTheme
                                                                                ? Colors.black
                                                                                : Colors.white,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            model.startDownloading(
                                                                                context,
                                                                                songs[index]['download_url'],
                                                                                songs[index]['name'],
                                                                                index);
                                                                          },
                                                                        )
                                                                      : model.downloadProgress !=
                                                                              100
                                                                          ? Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                CircularProgressIndicator(
                                                                                  strokeWidth: 5,
                                                                                  value: model.downloadProgress,
                                                                                  backgroundColor: Colors.grey[200],
                                                                                ),
                                                                                IconButton(
                                                                                  icon: Icon(
                                                                                    Icons.clear,
                                                                                    color: tb.darkTheme ? Colors.black : Colors.white,
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    model.stopDownloading(context, index);
                                                                                  },
                                                                                )
                                                                              ],
                                                                            )
                                                                          : Icon(
                                                                              Icons.check,
                                                                              color: tb.darkTheme ? Colors.black : Colors.white,
                                                                            ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )));
                              }),
                ),
              )
            ],
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    var _scaffoldKey = new GlobalKey<ScaffoldState>();

    ThemeBloc tb = Provider.of<ThemeBloc>(context);
    return buildArtist(_scaffoldKey, w, h, tb);
  }
}
