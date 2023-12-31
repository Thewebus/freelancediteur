import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freelancediteur/adapterView/DownloadFilesViewOffline.dart';
import 'package:freelancediteur/app_localizations.dart';
import 'package:freelancediteur/main.dart';
import 'package:freelancediteur/model/DashboardResponse.dart';
import 'package:freelancediteur/model/OfflineBookList.dart';
import 'package:freelancediteur/model/downloaded_book.dart';
import 'package:freelancediteur/utils/Colors.dart';
import 'package:freelancediteur/utils/app_widget.dart';
import 'package:freelancediteur/utils/constant.dart';
import 'package:freelancediteur/utils/database_helper.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class OfflineScreen extends StatefulWidget {
  bool _isPopOperation = false;
  bool _isShowBack = true;

  @override
  _OfflineScreenState createState() => _OfflineScreenState();

  OfflineScreen({isPopOperation = false, isShowBack = true}) {
    this._isPopOperation = isPopOperation;
    this._isShowBack = isShowBack;
  }
}

class _OfflineScreenState extends State<OfflineScreen> {
  final dbHelper = DatabaseHelper.instance;
  var downloadedList = <OfflineBookList>[];

  // bool mIsLoading = false;
  String firstName = "";

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  DownloadedBook? isExists(
      List<DownloadedBook> tasks, DashboardBookInfo mBookDetail) {
    DownloadedBook? exist;
    tasks.forEach((task) {
      if (task.bookId == mBookDetail.id.toString()) {
        exist = task;
      }
    });
    if (exist == null) {
      exist = defaultBook(mBookDetail, "purchased");
    }
    return exist;
  }

  @override
  void initState() {
    super.initState();
    fetchData(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget blankView = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(spacing_standard_30),
            child: Image.asset(
              "logo.png",
              width: 150,
            ),
          ),
          Text(
            keyString(context, 'lbl_book_not_available')!,
            style: boldTextStyle(size: 20, color: appStore.appTextPrimaryColor),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );

    Widget getList(List<OfflineBookList> list, context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 50),
          width: MediaQuery.of(context).size.width,
          child: (list.length < 1)
              ? blankView
              : Column(
                  children: [
                    GridView.builder(
                      itemCount: list.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: getChildAspectRatio(),
                        crossAxisCount: getCrossAxisCount(),
                      ),
                      controller: ScrollController(keepScrollOffset: false),
                      itemBuilder: (context, index) {
                        OfflineBookList bookDetail = list[index];
                        return GestureDetector(
                          onTap: () {
                            _settingModalBottomSheet(context, bookDetail);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            width: bookWidth,
                            height: bookHeight,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: 120,
                                  height: 150,
                                  child: Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Center(
                                        child: bookLoaderWidget,
                                      ),
                                      imageUrl: bookDetail.frontCover!,
                                      fit: BoxFit.fill,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(8),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Text(
                                      bookDetail.bookName!,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: appStore.textSecondaryColor,
                                          fontSize: 14),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(
        context,
        title: keyString(context, 'lbl_offline_book'),
        isPopOperation: widget._isPopOperation,
        showBack: widget._isShowBack,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [getList(downloadedList, context)],
      ),
    );
  }

  Future<void> fetchData(context) async {
    List<OfflineBookList>? books =
        await (dbHelper.queryAllRows(appStore.userId));
    if (books!.isNotEmpty) {
      downloadedList.clear();
      downloadedList.addAll(books);
      setState(() {});
    } else {
      setState(() {
        downloadedList.clear();
      });
    }
  }

  void _settingModalBottomSheet(context, OfflineBookList downloadData) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          primary: false,
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: spacing_standard_new,
                      ),
                      padding: EdgeInsets.only(right: spacing_standard),
                      child: Text(
                        "All Files",
                        style: boldTextStyle(
                            size: 20, color: appStore.appTextPrimaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.close,
                        color: appStore.iconColor,
                        size: 30,
                      ),
                      onTap: () => {Navigator.of(context).pop()},
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: spacing_standard_new),
                  height: 2,
                  color: lightGrayColor,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return DownloadFilesViewOffline(
                        downloadData.bookId,
                        downloadData.offlineBook[index],
                        downloadData.frontCover,
                        downloadData.bookName,
                      );
                    },
                    itemCount: downloadData.offlineBook.length,
                    shrinkWrap: true,
                  ),
                ).visible(downloadData.offlineBook.isNotEmpty),
              ],
            ),
          ),
        );
      },
    );
  }
}
