import 'dart:async';

import 'package:flutter/material.dart';
import 'colors.dart';
import './tab_pages/explore.dart' as explore;
import './tab_pages/addKE.dart' as addKE;
import './tab_pages/findKE.dart' as findKE;
import './tab_pages/myKE.dart' as myKE;
import './tab_pages/profile.dart' as profile;
import './tab_pages/scheduleKE.dart' as schedule;

final Color primary = mPrimaryColor;
final Color tab_unselected_color = Colors.grey;
final String title = 'Knowledge Exchange';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  @override
  deactivate() {
    super.deactivate();
  }

  int _currentTabIndex = 1;

  List tab_color = [
    tab_unselected_color,
    primary,
    tab_unselected_color,
    tab_unselected_color,
    tab_unselected_color,
    tab_unselected_color
  ];

  List titles = [
    'Tìm kiến KE',
    'Khám phá',
    'KE của tôi',
    'Tạo KE',
    'Lịch trình KE',
    'Giới thiệu',
  ];

  List icons = [
    Icons.search,
    Icons.explore,
    Icons.people,
    Icons.add,
    Icons.notifications,
    Icons.person
  ];

  List<Widget> tab_pages = [
    new findKE.FindKE(),
    new explore.Explore(),
    new myKE.MyKE(),
    new addKE.AddKE(),
    new schedule.ScheduleKE(),
    new profile.Profile()
  ];

  TabController controller;
  VoidCallback onChargePage;

  @override
  void initState() {
    super.initState();
    controller = new TabController(
      length: titles.length,
      vsync: this,
      initialIndex: 1,
    );
    onChargePage = () {
      setState(() {
        tab_color[_currentTabIndex] = Colors.grey;
        tab_color[controller.index] = primary;
        _currentTabIndex = controller.index;
        controller.index = _currentTabIndex;
      });
    };
    controller.addListener(onChargePage);
  }

  @override
  void dispose() {
    controller.removeListener(onChargePage);
    controller.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      tab_color[_currentTabIndex] = Colors.grey;
      tab_color[index] = primary;
      _currentTabIndex = index;
      controller.index = _currentTabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new TabBarView(
        children: tab_pages,
        controller: controller,
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: _onTabSelected,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                icons[0],
                color: tab_color[0],
              ),
              title: Text(
                titles[0],
                style: new TextStyle(color: tab_color[0]),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                icons[1],
                color: tab_color[1],
              ),
              title: Text(
                titles[1],
                style: new TextStyle(color: tab_color[1]),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                icons[2],
                color: tab_color[2],
              ),
              title: Text(
                titles[2],
                style: new TextStyle(color: tab_color[2]),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                icons[3],
                color: tab_color[3],
              ),
              title: Text(
                titles[3],
                style: new TextStyle(color: tab_color[3]),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                icons[4],
                color: tab_color[4],
              ),
              title: Text(
                titles[4],
                style: new TextStyle(color: tab_color[4]),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                icons[5],
                color: tab_color[5],
              ),
              title: Text(
                titles[5],
                style: new TextStyle(color: tab_color[5]),
              ))
        ],
      ),
    );
  }
}
