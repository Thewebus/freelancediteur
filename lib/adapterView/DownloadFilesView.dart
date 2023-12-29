import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freelancediteur/model/DashboardResponse.dart';
import 'package:freelancediteur/screens/EpubFilenew.dart';
import 'package:freelancediteur/screens/VideoBookPlayer.dart';
import 'package:freelancediteur/screens/audio_book_player_screen.dart';
import 'package:freelancediteur/utils/constant.dart';
import 'package:freelancediteur/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

// ignore: must_be_immutable
class DownloadFilesView extends StatefulWidget {
  DownloadModel downloads;
  String? bookImage = "";
  String? bookName = "";
  String mBookId = "0";
  bool? isOffline = false;
  bool isSampleFile = false;

  DownloadFilesView(this.mBookId, this.downloads, this.bookImage, this.bookName,
      {this.isOffline, this.isSampleFile = false});

  @override
  _DownloadFilesViewState createState() => _DownloadFilesViewState();
}

class _DownloadFilesViewState extends State<DownloadFilesView> {
  String fileUrl = "";
  bool _isPDFFile = false;
  bool _isVideoFile = false;
  bool _isAudioFile = false;
  bool _isEpubFile = false;
  bool _isDefaultFile = false;
  bool _isFileExist = false;
  String bookId = "0";

  @override
  void initState() {
    super.initState();

    fileUrl = widget.downloads.file.toString();

    final filename = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);

    if (filename.contains(".pdf")) {
      checkFileIsExist();
      _isPDFFile = true;
    } else if (filename.contains(".mp4") ||
        filename.contains(".mov") ||
        filename.contains(".webm")) {
      _isVideoFile = true;
      _isFileExist = true;
    } else if (filename.contains(".mp3") || filename.contains(".flac")) {
      _isAudioFile = true;
      _isFileExist = true;
    } else if (filename.contains(".epub")) {
      checkFileIsExist();
      _isEpubFile = true;
    } else {
      _isFileExist = true;
      _isDefaultFile = true;
    }
  }

  checkFileIsExist() async {
    String path = (await getBookFilePath(widget.mBookId, widget.downloads.file!,
        isSampleFile: widget.isSampleFile));

    //log("Verifications >>>> id: ${widget.mBookId} ...  Fichier: ${widget.downloads.file!} ");
    //log("Verifications >>>> isSampleFile ? : ${widget.isSampleFile} !!");
    //log("Verifications >>>> getBookFilePath : ${path}");

    if (!File('$path.aes').existsSync()) {
      log("_isFileExist False");
      setState(() {
        _isFileExist = false;
      });
    } else {
      log("_isFileExist true");
      setState(() {
        _isFileExist = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (_isPDFFile)
                        Image.asset("assets/pdf.png",
                            width: 24, color: appStore.iconColor),
                      if (_isVideoFile)
                        Image.asset("assets/video.png",
                            width: 24, color: appStore.iconColor),
                      if (_isAudioFile)
                        Image.asset("assets/music.png",
                            width: 24, color: appStore.iconColor),
                      if (_isEpubFile)
                        Image.asset("assets/epub.png",
                            width: 24, color: appStore.iconColor),
                      if (_isDefaultFile)
                        Image.asset("assets/default.png",
                            width: 24, color: appStore.iconColor),
                      8.width,
                      Expanded(
                        child: Text(widget.downloads.name!,
                            textAlign: TextAlign.start,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontSize: 18,
                                color: appStore.appTextPrimaryColor)),
                      )
                    ],
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: (!_isFileExist)
                      ? Image.asset("assets/downloads.png",
                          color: appStore.iconColor, width: 24)
                      : SizedBox(),
                  flex: 1,
                )
              ],
            ),
            Container(
                margin: EdgeInsets.only(
                    top: spacing_standard_new, bottom: spacing_standard),
                height: 1)
          ],
        ),
      ),
      onTap: () async {
        Navigator.of(context).pop();
        if (_isPDFFile) {
          log("Verifications >>>> File to see _isPDFFile ");
          log("Verifications >>>> id: ${widget.mBookId} ");

          log("Verifications >>>> bookName: ${widget.bookName} ");
          log("Verifications >>>> bookImage: ${widget.bookImage} ");
          //log("Verifications >>>> downloads: ${widget.downloads} ");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewEPubFileNew(
                  widget.mBookId,
                  widget.bookName,
                  widget.bookImage,
                  widget.downloads,
                  true,
                  _isFileExist),
            ),
          );
        } else if (_isVideoFile) {
          log("Verifications >>>> File to see _isVideoFile ");
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideoBookPlayer(widget.downloads)),
          );
        } else if (_isAudioFile) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AudioBookPlayer(
                  url: widget.downloads.file,
                  bookImage: widget.bookImage,
                  bookName: widget.bookName),
            ),
          );
        } else if (_isEpubFile) {
          log("Verifications >>>> File to see _isEpubFile ");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewEPubFileNew(
                  widget.mBookId,
                  widget.bookName,
                  widget.bookImage,
                  widget.downloads,
                  false,
                  _isFileExist),
            ),
          );
        } else {
          toast("File format not supported.");
          log("Verifications >>>> File to see format not supported ! ");
        }
      },
    );
  }
}
