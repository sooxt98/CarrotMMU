
import 'package:carrotmmu/logic/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';

class Timetable extends StatefulWidget {
  @override
  _TimetableState createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> with AutomaticKeepAliveClientMixin<Timetable>{
  List timetable;
  final List<String> items = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTimetable();
  }

  void initTimetable() async {
    var timetableData = await API.timetable();
    print(timetable?.length ?? 0);
    if(this.mounted) setState(() {
      timetable = timetableData;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return (timetable?.length ?? 0) <= 0 ?  Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber))) : SingleChildScrollView(
          child: (timetable?.length ?? 0) <= 0 ? Row() : Column(children: [
        ...items.map((e) {

          List day = timetable.where((element) => element['weekday'] == e).toList();
          day = day..sort((a,b) => DateFormat("hh:mma").parse(a['time'].split("-")[0]).compareTo(DateFormat("hh:mma").parse(b['time'].split("-")[0])));
          
          if(day.length > 0)
          return Column(
            // mainAxisSize: MainAxisSize.max,
            children: [
              // Container(color:Colors.black, width:double.infinity, height: 20,),
              Text(e, style: GoogleFonts.lato()).textColor(Theme.of(context)
                                .textTheme
                                .bodyText1
                                .color
                                .withOpacity(.8))
                               
                            .fontSize(16)
                            .fontWeight(FontWeight.bold).padding(horizontal: 18, top: 5, bottom: 15).alignment(Alignment.centerLeft),
              ListView.builder(
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: day.length,
                itemBuilder: (context, index) {
                  
                return Container(
                  padding: EdgeInsets.fromLTRB(20, 15,15,15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(day[index]['name']).fontSize(13)
                            .fontWeight(FontWeight.bold),
                      Row(children: [
                        Text(day[index]['type'].toUpperCase()).fontSize(10).fontWeight(FontWeight.bold).textColor(Colors.grey.shade500),
                       Text(" . "),
                      Text(day[index]['code']).fontSize(10).fontWeight(FontWeight.bold).textColor(Colors.grey.shade500),
                      Text(" . "),
                      Text(day[index]['venue']).fontSize(10).fontWeight(FontWeight.bold).textColor(Colors.grey.shade500),
                      ]),
                      Text(day[index]['time']).padding(top:5),
                      // Text(day[index]['time']),
                    ],
                  ),
                ).width(double.infinity)
                
                        .decorated(
                          border: Border(left: BorderSide(color: Colors.amber.shade200, width: 8)),
                            color: Theme.of(context).cardColor,
                            // borderRadius: BorderRadius.circular(15),
                        ).clipRRect(all: 15).decorated(
                
                            boxShadow: [
                          BoxShadow(
                              blurRadius: 20,
                              color: Colors.black.withOpacity(.1),
                              offset: Offset(0, 8))
                        ])


               .padding(horizontal: 15, bottom: 15);
              },),
            ],
          );

          return SizedBox();

        }).toList(),

        SizedBox(height: 90)
      ],),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}