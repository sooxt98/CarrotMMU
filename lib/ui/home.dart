import 'package:carrotmmu/logic/api.dart';
import 'package:carrotmmu/widget/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

Widget card({Widget child}) => child
    .padding(all: 20)
    .backgroundColor(Colors.white)
    .borderRadius(all: 5)
    .elevation(10);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  List attendance;
  List announcement;
  String selectedAttendance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAttendance();
    initAnnoucement();
  }

  void initAttendance() async {
    var attendanceData = await API.attendance();
    print(attendance?.length ?? 0);
    setState(() {
      attendance = attendanceData;
    });
  }

  void initAnnoucement() async {
    var announcementData = await API.announcement();
    print(announcement?.length ?? 0);
    setState(() {
      announcement = announcementData;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: Colors.amber,
      onRefresh: () async {
        print('aaaaaa');
        await initAttendance();
        await initAnnoucement();
        // return;
      },
      child: (announcement?.length ?? 0) <= 0
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber)))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  // Text("Attendance", style: GoogleFonts.lato())
                  //     .textColor(
                  //         Theme.of(context).textTheme.bodyText1.color.withOpacity(.5))
                  //     .fontSize(22)
                  //     .fontWeight(FontWeight.bold)
                  //     .padding(horizontal: 18, top: 5, bottom: 15),
                  SizedBox(
                    height: 225,
                    child: ListView.builder(
                      padding: EdgeInsets.only(left: 15),
                      itemCount: attendance?.length ?? 0,
                      clipBehavior: Clip.none,
                      // This next line does the trick.
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        var percentage =
                            double.parse(attendance[index]['current_per']);

                        print(index);
                        return GestureDetector(
                          onTap: () async {
                            MyApp.observer.analytics.setCurrentScreen(
      screenName: '/attendance',
    );
                            setState(() {
                                                          selectedAttendance = index.toString();
                                                        });
                            var history = await API.attendanceDetail(index.toString());
setState(() {
                                                          selectedAttendance = "";
                                                        });
                                                        print('gg');
                            print(history);
                            print('gg ennd');
                            showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context, scrollController) => Material(
                                color: Colors.transparent,
                                child: Container(
child: Column(children: [
  SizedBox(height: 10,),
  Text(attendance[index]['code'])
                                    .textColor(Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color)
                                    .fontSize(20)
                                    .fontWeight(FontWeight.bold)
                                    .padding(top: 4),
                                Text(
                                  attendance[index]['name'],
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                )
                                    .textColor(Colors.grey.shade500)
                                    .fontWeight(FontWeight.bold)
                                    .fontSize(10)
                                    .padding(horizontal: 10),
                                Text(attendance[index]['type'])
                                    .textColor(Colors.grey.shade500)
                                    .fontWeight(FontWeight.bold)
                                    .fontSize(11),


Expanded(
  child:  (history.length == 0) ? Center(child: Padding(
    padding: const EdgeInsets.all(18.0),
    child: Text('oof, fail to get attendance history'),
  )) : ListView.builder(
                        // shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 15, bottom: 25),
                        itemCount: history?.length ?? 0,
                        // clipBehavior: Clip.none,
                        // This next line does the trick.
                        // scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 8,
                      offset: Offset(0, 15),
                      color: Colors.black.withOpacity(.1),
                      spreadRadius: -9)
                ]),

                            // elevation: 10,
                            margin: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical:8.0, horizontal: 15),
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Text(history[index]['date'] + " ("+ history[index]['start'] + ' - ' + history[index]['end'] + ')'),
                              if(history[index]['present']) Text("🥕"),
                          ],),
                            ));
                        }
  ),
)

],),
                                )));
                          },
                          child: Container(
                            width: 160.0,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(height: 4),
                                    SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                              child: CustomPaint(
                                                  painter:
                                                      Arc(percentage * 360 / 100))),
                                          Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  //  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(percentage
                                                            .toStringAsFixed(0))
                                                        .fontSize(28)
                                                        .fontWeight(FontWeight.bold)
                                                        .textColor(Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            .color)
                                                        .padding(left: 6),
                                                    Text("%")
                                                        .fontSize(12)
                                                        .padding(top: 12),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(attendance[index]['code'])
                                        .textColor(Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .color)
                                        .fontSize(20)
                                        .fontWeight(FontWeight.bold)
                                        .padding(top: 4),
                                    Text(
                                      attendance[index]['name'],
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      softWrap: false,
                                    )
                                        .textColor(Colors.grey.shade500)
                                        .fontWeight(FontWeight.bold)
                                        .fontSize(10)
                                        .padding(horizontal: 10),
                                    Text(attendance[index]['type'])
                                        .textColor(Colors.grey.shade500)
                                        .fontWeight(FontWeight.bold)
                                        .fontSize(11),
                                  ],
                                ),

                                if(selectedAttendance == index.toString()) Positioned.fill(
                                    child: Container(
                                            color: Colors.amber.withOpacity(.2),
                                            child: CupertinoActivityIndicator())
                                        .clipRRect(all: 15)),
                                        
                              ],
                            ),
                          ).decorated(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 20,
                                    color: Colors.black.withOpacity(.1),
                                    offset: Offset(0, 8))
                              ]).padding(right: 12),
                        );
                      },
                    ),
                  ),
                  Text("Annoucement", style: GoogleFonts.lato())
                      .textColor(Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color
                          .withOpacity(.8))
                      .fontSize(16)
                      .fontWeight(FontWeight.bold)
                      .padding(horizontal: 18, top: 25, bottom: 15),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      // padding: EdgeInsets.only(left: 15),
                      itemCount: announcement?.length ?? 0,
                      clipBehavior: Clip.none,
                      // This next line does the trick.
                      // scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            MyApp.observer.analytics.setCurrentScreen(
      screenName: '/annnouncement',
    );
                            showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context, scrollController) => Material(
                                color: Colors.transparent,
                                child: Container(
                                    child: Column(
                                  children: [
                                    
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(.05),
                                              blurRadius: 20,
                                            )
                                          ]),
                                      // color: Colors.amber.shade100,
                                      child: Text(announcement[index]['title'])
                                          .textColor(Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .color
                                              .withOpacity(.8))
                                          .fontSize(16)
                                          .fontWeight(FontWeight.bold)
                                          .padding(
                                              vertical: 15, horizontal: 10),
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                          child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: Html(
                                                onLinkTap: (url) {
                                                  launch(url);
                                                },
                                                blacklistedElements: ["img"],
                                                style: {
                                                  "*": Style(
                                                      // color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500
                                                      // backgroundColor: Colors.black
                                                      ),
                                                  "a": Style(
                                                      textDecoration:
                                                          TextDecoration.none,
                                                      color:
                                                          Colors.amber.shade700)
                                                },
                                                onImageError:
                                                    (exception, stackTrace) {},
                                                data: announcement[index]
                                                    ['content']),
                                          ),
                                          if (announcement[index]
                                                  ['attachment'] !=
                                              null)
                                            ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: announcement[index]
                                                      ['attachment']
                                                  .length,
                                              itemBuilder: (context, i) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                                                                      child: FlatButton(
                                                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                                      color: Colors.amber.shade100,
                                                      onPressed: () {
                                                        launch(announcement[index]
                                                                ['attachment']
                                                            [i]['link']);
                                                      },
                                                      child: Text(
                                                          announcement[index]
                                                                  ['attachment']
                                                              [i]['name'].substring(7).replaceAll('_', ' ') ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                18.0),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          SizedBox(height: 60)
                                        ],
                                      )),
                                    ),
                                  ],
                                )),
                              ),
                            );
                          },
                          child: Container(
                                  child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(announcement[index]['title'])
                                  .textColor(Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color
                                      .withOpacity(.8))
                                  .fontSize(15)
                                  .fontWeight(FontWeight.bold),
                              Text(announcement[index]['meta'])
                                  .textColor(Colors.grey.shade500)
                                  .fontSize(9)
                                  .fontWeight(FontWeight.bold)
                                  .padding(top: 5)
                            ],
                          ).padding(all: 15))
                              .ripple()
                              .clipRRect(all: 15)
                              .width(double.infinity)
                              .decorated(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                BoxShadow(
                                    blurRadius: 20,
                                    color: Colors.black.withOpacity(.1),
                                    offset: Offset(0, 8))
                              ]).padding(horizontal: 15, bottom: 15),
                        );
                      }),
                ],
              ),
            ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
