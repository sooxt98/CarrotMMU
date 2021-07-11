import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:carrotmmu/logic/api.dart';
import 'package:carrotmmu/ui/pdf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:styled_widget/styled_widget.dart';

import '../main.dart';

class Pastyear extends StatefulWidget {
  @override
  _PastyearState createState() => _PastyearState();
}

class _PastyearState extends State<Pastyear>
    with AutomaticKeepAliveClientMixin<Pastyear> {
  List timetable;
  List items;
  String selected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTimetable();
  }

  void initTimetable() async {
    var timetableData = await API.timetable();
    print(timetable?.length ?? 0);
    items = timetableData.map((e) => e['code']).toSet().toList();
    if(this.mounted) setState(() {
      timetable = timetableData;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return (timetable?.length ?? 0) <= 0
        ? Center(
            child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber)))
        : SingleChildScrollView(
            child: (timetable?.length ?? 0) <= 0
                ? Row()
                : Column(
                    children: [
                      Text("Pastyear Paper", style: GoogleFonts.lato())
                          .textColor(Theme.of(context)
                              .textTheme
                              .bodyText1
                              .color
                              .withOpacity(.5))
                          .fontSize(22)
                          .fontWeight(FontWeight.bold)
                          .padding(horizontal: 18, top: 5, bottom: 25)
                          .alignment(Alignment.centerLeft),
                      ...items.map((e) {
                        var current = timetable
                            .firstWhere((element) => element['code'] == e);

                        return GestureDetector(
                          onTap: () async {
                            setState(() {
                              selected = current['code'];
                            });
                            MyApp.observer.analytics.setCurrentScreen(
                              screenName: '/paper/' + current['code'],
                            );
                            var pastyear = await API.pastyear(current['code']);
                            setState(() {
                              selected = "";
                            });
                            print('gg');
                            print(pastyear);
                            print('gg ennd');
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
                                      child: Text(current['name'])
                                          .textColor(Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .color
                                              .withOpacity(.8))
                                          .fontSize(14)
                                          .fontWeight(FontWeight.bold)
                                          .padding(
                                              vertical: 15, horizontal: 10),
                                    ),
                                    Expanded(
                                        child: (pastyear.length == 0) ? Center(child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Text("oof, there's no pastyear paper for this subject, if you think it's an error please report this to us on fb for us to fix it."),
                                        )) : ListView.builder(
                                      itemCount: pastyear.length,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            showCupertinoModalBottomSheet(
                                                context: context,
                                                builder: (context,
                                                        scrollController) =>
                                                    Material(
                                                        child: Pdf(
                                                            API.pastyearView(
                                                                pastyear[index]
                                                                    ['id']))));
                                          },
                                          child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: Column(
                                                    children: [
                                                      Text('${pastyear[index]['name']}')
                                                          .textAlignment(
                                                              TextAlign.center)
                                                          .fontWeight(
                                                              FontWeight.bold),
                                                      Text(
                                                          '${pastyear[index]['term']}'),
                                                      Text(
                                                          '${pastyear[index]['year']}'),
                                                    ],
                                                  ))
                                              .ripple()
                                              .clipRRect(all: 15)
                                              .decorated(
                                                  // border: Border(left: BorderSide(color: Colors.amber, width: 10)),
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 20,
                                                    color: Colors.black
                                                        .withOpacity(.1),
                                                    offset: Offset(0, 8))
                                              ]).padding(
                                                  horizontal: 15, bottom: 15),
                                        );
                                      },
                                    )),
                                  ],
                                )),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(current['name'])
                                        .fontSize(14)
                                        .fontWeight(FontWeight.bold),
                                    Text(current['code']).padding(top: 3),
                                    // Text(day[index]['time']),
                                  ],
                                ),
                              )
                                  .width(double.infinity)
                                  .ripple()
                                  .clipRRect(all: 15)
                                  .decorated(
                                      // border: Border(left: BorderSide(color: Colors.amber, width: 10)),
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                    BoxShadow(
                                        blurRadius: 20,
                                        color: Colors.black.withOpacity(.1),
                                        offset: Offset(0, 8))
                                  ]).padding(horizontal: 15, bottom: 15),
                              if (selected == current['code'])
                                Positioned.fill(
                                    child: Container(
                                            color: Colors.amber.withOpacity(.2),
                                            child: CupertinoActivityIndicator())
                                        .clipRRect(all: 15)
                                        .padding(horizontal: 15, bottom: 15)),
                            ],
                          ),
                        );
                      }).toList()
                    ],
                  ),
          );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
