import 'package:chat_app_29_9_2015/anim_search_bar/anim_search_bar.dart';
import 'package:chat_app_29_9_2015/provider/chat_provider.dart';
import 'package:chat_app_29_9_2015/screen/main_screen_pages/camera_page.dart';
import 'package:chat_app_29_9_2015/screen/main_screen_pages/contacts_page.dart';
import 'package:chat_app_29_9_2015/screen/main_screen_pages/settings_page.dart';
import 'package:chat_app_29_9_2015/screen/main_screen_pages/statues_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    getSwitchValues();
    tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    super.initState();
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    dynamic _height = MediaQuery.of(context).size.height;
    dynamic _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Provider.of<ChatProvider>(context).backGroundColor,
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: _width * 0.032),
            child: AnimSearchBar(
              color: Provider.of<ChatProvider>(context).mainColor,
              width: _width * 0.6,
              helpText: 'search by name',
              closeSearchOnSuffixTap: true,
              textController:
                  Provider.of<ChatProvider>(context).searchController,
              onSuffixTap: () {
                //* first im checking if the text controller is empty
                //* if not search for the user else dont search
                Provider.of<ChatProvider>(context, listen: false)
                        .searchController
                        .text
                        .isNotEmpty
                    ? Provider.of<ChatProvider>(context, listen: false)
                        .searchForUserByName(
                            Provider.of<ChatProvider>(context, listen: false)
                                .searchController
                                .text)
                    : null;
                //* here im opening the search bar where the result will appear
                Provider.of<ChatProvider>(context, listen: false)
                        .searchController
                        .text
                        .isNotEmpty
                    ? Provider.of<ChatProvider>(context, listen: false)
                        .openSearchBar()
                    : null;
                //* finally clear the text controller
                Provider.of<ChatProvider>(context, listen: false)
                    .searchController
                    .clear();
              },
            ),
          ),
        ],
        title: const Text('Chat app'),
        backgroundColor: Provider.of<ChatProvider>(context).mainColor,
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.camera_alt)),
            Tab(text: 'Contacts'),
            Tab(
              text: 'Status',
            ),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          CameraPage(),
          ContactPage(),
          StatuesPage(),
          SettingPage(),
        ],
      ),
    );
  } //*  this method is to get the switch widget value from shared preferences

  getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var result = prefs.getBool('darkMood') ?? false;
    return result;
  }

  //* This method is to handle the value from shared preferences
  getSwitchValues() async {
    Provider.of<ChatProvider>(context, listen: false).darkMood =
        await getDataFromSharedPreferences();
    Provider.of<ChatProvider>(context, listen: false).changeColor();
    Provider.of<ChatProvider>(context, listen: false).changeScaffoldColor();
    Provider.of<ChatProvider>(context, listen: false).changingTextColor();
    setState(() {});
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }
}
