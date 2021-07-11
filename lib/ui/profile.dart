import 'package:carrotmmu/logic/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:styled_widget/styled_widget.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
    with AutomaticKeepAliveClientMixin<Profile> {
  Map profile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initProfile();
  }

  void initProfile() async {
    var profileData = await API.profile();
    // print(profile?.length ?? 0);
    if(this.mounted) setState(() {
      profile = profileData;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: Colors.amber,
      onRefresh: () async {
        print('aaaaaa');
        await initProfile();
        // return;
      },
      child: (profile?.length ?? 0) <= 0
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber)))
          : SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical,
                child: Column(
                children: [
                  SizedBox(height: 24),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: NetworkImage(
                        "https://mmls.mmu.edu.my/img/student/" + box.read("uid") + ".png"),
                  ),
                  SizedBox(height: 25),
                  Text(profile['name']).fontWeight(FontWeight.bold).fontSize(18),
                  SizedBox(height: 5),
                  Text(profile['campus']),
                  SizedBox(height: 2),
                  Text(profile['term']).fontSize(12),
                  SizedBox(height: 35),

                  // Text('Advisor').fontSize(14).fontWeight(FontWeight.bold).textColor(Theme.of(context).textTheme.bodyText1.color.withOpacity(.5)).alignment(Alignment.centerLeft).padding(left: 28),
                  Container(
                          child: Row(
                    children: [
                      Icon(FeatherIcons.user, color: Colors.grey.shade800)
                          .backgroundColor(Colors.amber.shade200)
                          .width(60)
                          .height(60)
                          .clipRRect(all: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          // SizedBox(height: 2),
                          Text(profile['advisor_name']).fontSize(16),
                          // SizedBox(height: 1),
                          Text(profile['advisor_mail']).fontSize(12),
                        ],
                      ).padding(left: 20),
                    ],
                  ).padding(all: 15))
// .alignment(Alignment.center)
                      .width(double.infinity)
                      .ripple()
                      .backgroundColor(Theme.of(context).cardColor)
                      .clipRRect(all: 25)
                      .elevation(
                        20,
                        borderRadius: BorderRadius.circular(25),
                        shadowColor: Color(0x10000000),
                      ) // shadow borderRadius

                      // .constrained(height: 80)

                      .padding(all: 15),


Container(
                          child: Row(
                    children: [
                      Icon(FeatherIcons.dollarSign, color: Colors.grey.shade800)
                          .backgroundColor(Colors.amber.shade200)
                          .width(60)
                          .height(60)
                          .clipRRect(all: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          // SizedBox(height: 2),
                          Text("Outstanding Fees").fontSize(16),
                          // SizedBox(height: 2),
                          Text("RM " + profile['fee']).fontSize(12),
                        ],
                      ).padding(left: 20),
                    ],
                  ).padding(all: 15))
// .alignment(Alignment.center)
                      .width(double.infinity)
                      .ripple()
                      .backgroundColor(Theme.of(context).cardColor)
                      .clipRRect(all: 25)
                      .elevation(
                        20,
                        borderRadius: BorderRadius.circular(25),
                        shadowColor: Color(0x10000000),
                      ) // shadow borderRadius

                      // .constrained(height: 80)

                      .padding(left: 15, right: 15),



                  SizedBox(
                    height: 15,
                  ),
                  Container(
                          child: Row(
                    children: [
                      Icon(FeatherIcons.externalLink,
                          color: Colors.red.shade800, size: 12),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Logout").textColor(Colors.red.shade800)
                    ],
                  ).padding(all: 15))
                      .width(double.infinity)
                      .ripple()
                      .gestures(onTap: () {
                        API.logout();
                      })
                      .backgroundColor(Theme.of(context).cardColor)
                      .clipRRect(all: 25)
                      .elevation(
                        0,
                        borderRadius: BorderRadius.circular(25),
                        shadowColor: Color(0x30000000),
                      )
                      .padding(all: 15)

                      
                ],
            ),
              )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
