import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:kotturata/utils/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadProgressModel extends ChangeNotifier {
  double _progress = -1;

  get downloadProgress => _progress;

  var request;
  Client client;

  void stopDownloading(context) async {
    client.close();
    _progress = -1;
    openToast1(context, "Download cancelled");
    notifyListeners();
  }

  void startDownloading(context, downloadUrl, fileName) async {
    _progress = null;
    notifyListeners();

    final url = downloadUrl;
    request = Request('GET', Uri.parse(url));
    client = Client();
    final StreamedResponse response = await client.send(request);

    final contentLength = response.contentLength;
    // final contentLength = double.parse(response.headers['x-decompressed-content-length']);

    _progress = 0;
    notifyListeners();

    List<int> bytes = [];

    final file = await _getFile(fileName + ".mp3", context);
    response.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
        final downloadedLength = bytes.length;
        _progress = downloadedLength / contentLength;
        notifyListeners();
      },
      onDone: () async {
        _progress = 100;
        notifyListeners();
        await file.writeAsBytes(bytes);
        openToast1(
            context, "Download successful. File saved to downloads directory.");
        Future.delayed(const Duration(milliseconds: 500), () {
          _progress = -1;
          notifyListeners();
        });
      },
      onError: (e) {
        print(e);
      },
      cancelOnError: true,
    );
  }

  Future<File> _getFile(String filename, context) async {
//    final dir = await getDownloadsDirectory();
    var status = await Permission.storage.status;
    if (status.isUndetermined) {
      Map<Permission, PermissionStatus> permissions = await [
        Permission.storage,
      ].request();

      if (permissions[Permission.storage] == PermissionStatus.denied) {
        openToast(
            context, 'Download aborted due to missing storage permission.');
      }
    }

    String dir;
    if (Platform.isIOS) {
      dir = (await getApplicationDocumentsDirectory()).path;
    } else if (Platform.isAndroid) {
      dir = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
    }
    print("$dir/$filename");
    return File("$dir/$filename");
  }
}
