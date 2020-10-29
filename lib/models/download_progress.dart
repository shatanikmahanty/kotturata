import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:kotturata/utils/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';

class DownloadProgressModel extends ChangeNotifier {
  double _progress = -1;

  get downloadProgress => _progress;

  var request;
  Client client;

  void stopDownloading(BuildContext context,int id) async {
    client.close();
    flutterLocalNotificationsPlugin.cancel(id);
    _progress = -1;
    openToast1(context, "Download cancelled");
    notifyListeners();
  }

  Future<void> _showProgressNotification(int id, String name) async {
    const int maxProgress = 100;
    while (true) {
      if (_progress < 0 || _progress == 100) {
        flutterLocalNotificationsPlugin.cancel(id);
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 1), () async {
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails('download channel', 'download channel',
                'channel for downloading',
                channelShowBadge: false,
                importance: Importance.max,
                priority: Priority.high,
                onlyAlertOnce: true,
                showProgress: true,
                maxProgress: maxProgress,
                progress: (_progress * 100).toInt());
        final NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            id,
            'Downloading $name.mp3......',
            '${(_progress * 100).toInt()}%',
            platformChannelSpecifics,
            payload: 'item x');
      });
    }
  }

  Future<void> _showDownloadCompleteNotification(int id, String name) async {
    await Future<void>.delayed(const Duration(milliseconds: 1), () async {
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'download channel',
        'download channel',
        'channel for downloading',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
      );
      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(id, 'Download complete',
          'Successfully downloaded $name.mp3', platformChannelSpecifics,
          payload: 'item x');
    });
  }

  void startDownloading(BuildContext context, String downloadUrl,
      String fileName, int index) async {
    _progress = null;
    notifyListeners();

    final url = downloadUrl;
    request = Request('GET', Uri.parse(url));
    client = Client();
    final StreamedResponse response = await client.send(request);

    final contentLength = response.contentLength;
    // final contentLength = double.parse(response.headers['x-decompressed-content-length']);

    _progress = 0;
    _showProgressNotification(index, fileName);
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
        _showDownloadCompleteNotification(index, fileName);
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
