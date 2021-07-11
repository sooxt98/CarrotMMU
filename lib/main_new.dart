import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:carrotmmu/ui/home.dart';
import 'package:carrotmmu/ui/timetable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// void main() => runApp(TabPage());

main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(brightness: Brightness.light),
    textTheme: GoogleFonts.nunitoTextTheme(
      ThemeData(brightness: Brightness.light).textTheme,
    ),
  ),
  darkTheme: ThemeData(
    // backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.grey.shade900,
    textTheme: GoogleFonts.nunitoTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ).copyWith(
      bodyText1: TextStyle(color: Colors.white),
      
    ),

  ),
  // darkTheme: ThemeData.dark(),
      title: 'Flutter Demo',
      // home: App(),

    onGenerateRoute: (settings) {
    // If you push the PassArguments route
    if (settings.name == '/') {
      // Cast the arguments to the correct type: ScreenArguments.
    

      // Then, extract the required data from the arguments and
      // pass the data to the correct screen.
      return MaterialWithModalsPageRoute(
        builder: (context) {
          return App();
        },
      );
    }
  },

    );
  }
}


class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int selectedIndex = 0;
  var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);
  double gap = 10;

  // PageController controller = PageController();

int pageIndex = 0;

  final List<Widget> pageList = <Widget>[
    Home(),
    Timetable(),

  ];

  @override
  void initState() {
    super.initState();

    var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);
    double gap = 10;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // builder: (context, widget) => Theme(data: ThemeData.dark(), child: widget),
      
  // themeMode:ThemeMode.dark,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.transparent,elevation: 0,),
        // backgroundColor: Colors.white,
        extendBody: true,
        body: SafeArea(
          // top:false,
            bottom: false,

          child: PageTransitionSwitcher(
            transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: IndexedStack(
        index: pageIndex,
        key: ValueKey<int>(pageIndex),
        children: [
          Home(),
          Timetable(),
        ],
      ),
      
        //       onPageChanged: (page) {
        //         setState(() {
        // selectedIndex = page;
   
        //         });
        //       },
        //       controller: controller,
              // children: [
                
              //   Home(),
              //   Timetable(),
              // ],
            ),
          ),
        // backgroundColor: Colors.green,
        // body: Container(color: Colors.red,),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 0,
                      blurRadius: 40,
                      color: Colors.black.withOpacity(.15),
                      offset: Offset(0, 20))
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2),
              child: GNav(
                tabBackgroundColor: Colors.amber[50],
                activeColor: Colors.amber[800],
                color: Colors.grey.shade500,
                  curve: Curves.easeOutExpo,
                  duration: Duration(milliseconds: 900),
                  tabs: [
                    GButton(
                      gap: gap,

                      iconSize: 22,
                      padding: padding,
                      icon: FeatherIcons.home,
                      // textStyle: t.textStyle,
                      text: 'Home',
                    ),
                    GButton(
                      gap: gap,
                      iconSize: 22,
                      padding: padding,
                      icon: FeatherIcons.calendar,
                      text: 'Timetable',
                    ),
                    GButton(
                      gap: gap,
                      iconSize: 22,
                      padding: padding,
                      icon: FeatherIcons.paperclip,
// textStyle: t.textStyle,
                      text: 'Papers',
                    ),
                    GButton(
                      gap: gap,
                      iconSize: 22,
                      padding: padding,
                      icon: FeatherIcons.user,
                      leading: CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(
                              "https://sooxt98.space/content/images/size/w100/2019/01/profile.png")),
// textStyle: t.textStyle,
                      text: 'Sheldon',
                    )
                  ],
                  selectedIndex: pageIndex,
                  onTabChange: (index) {
                    // _debouncer.run(() {

                    print(index);
                    setState(() {
                      pageIndex = index;
                      // badge = badge + 1;
                    });
                    // controller.jumpToPage(index);
                    // });
                  }),
            ),
          ),
        ),
      ),
    );
  }
}