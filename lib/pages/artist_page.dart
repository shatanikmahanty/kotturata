import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kotturata/models/download_progress.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage(
      {Key key, @required this.artistName, @required this.artistImageUrl,@required this.tag})
      : super(key: key);

  final String artistName, artistImageUrl,tag;

  @override
  _ArtistPageState createState() =>
      _ArtistPageState(this.artistName, this.artistImageUrl,this.tag);
}

class _ArtistPageState extends State<ArtistPage> {
  TextEditingController searchController = new TextEditingController();
  bool isSearching = false;
  String searchQuery = '';
  var formKey = GlobalKey<FormState>();

  final String artistName, artistImageUrl,tag;

  List songs = [];

  _ArtistPageState(this.artistName, this.artistImageUrl, this.tag);

  bool isLoading = true;

  Future getSongs() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('songs')
        .where('artist', isEqualTo: artistName)
        .get();
    var x = snap.docs;
    songs.clear();
    x.forEach((f) {
      songs.add(f);
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  Widget buildArtist(_scaffoldKey, double w) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      key: _scaffoldKey,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.black.withOpacity(0.7),
                expandedHeight: 350,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(children: [
                    Hero(
                      tag: tag,
                      child: Container(
                        width: w,
                        child: CachedNetworkImage(
                          imageUrl: artistImageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          artistName,
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.9),

                          ),
                        ),
                      ),
                    )
                  ]),
                  collapseMode: CollapseMode.parallax,
                  //CachedNetworkImageProvider(imageUrl),
                ),
              ),
            ];
          },
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : ListView.builder(
                  itemCount: songs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: w - 30,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 8,
                                )
                              ]),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 60,
                                padding: EdgeInsets.only(left: 5.0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${index + 1}.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                height: 60,
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    songs[index]['name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
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
                                  builder: (context, model, child) => Stack(
                                    children: <Widget>[
                                      Center(
                                        child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: model.downloadProgress == null
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : model.downloadProgress < 0
                                                  ? IconButton(
                                                      icon: Icon(
                                                        Icons.file_download,
                                                      ),
                                                      onPressed: () {
                                                        model.startDownloading(
                                                            context,
                                                            songs[index][
                                                                'download_url'],
                                                            songs[index]
                                                                ['name']);
                                                      },
                                                    )
                                                  : model.downloadProgress !=
                                                          100
                                                      ? Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            CircularProgressIndicator(
                                                              strokeWidth: 5,
                                                              value: model
                                                                  .downloadProgress,
                                                              backgroundColor:
                                                                  Colors.grey[
                                                                      200],
                                                            ),
                                                            IconButton(
                                                              icon: Icon(
                                                                  Icons.clear),
                                                              onPressed: () {
                                                                model.stopDownloading(
                                                                    context);
                                                              },
                                                            )
                                                          ],
                                                        )
                                                      : Icon(Icons.check),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ));
                  })),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    // double h = MediaQuery.of(context).size.height;
    var _scaffoldKey = new GlobalKey<ScaffoldState>();

    return buildArtist(_scaffoldKey, w);
  }
}
