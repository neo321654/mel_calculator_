// import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:mel_calculator_/src/settings/settings_controller.dart';
import 'package:mel_calculator_/src/settings/settings_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {

  static const routeName = '/';

  final SettingsController controller;

  const MainScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

enum TimeType { t12, t24 }

class _MainScreenState extends State<MainScreen> {
    //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    int categoryADelay = 0;
    int categoryBDelay = 3;
    int categoryCDelay = 10;
    int categoryDDelay = 120;

    DateTime now = DateTime.now();
    String dateNow = "";
    String dateNowPlus3 = "";
    String dateNowPlus10 = "";
    String dateNowPlus120 = "";

    TimeType? _character = TimeType.t12;

    var monthStrings = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    final BannerAdListener listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened1.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed111.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    );

    late final AdWidget adWidget;
    late final BannerAd myBanner;
    late Color _color;


    int _selectedDestination = 0;
//
    getSettings() async {
      print("getSet");
      categoryADelay = await widget.controller.prefs.then((SharedPreferences prefs) {
        return (prefs.getInt('CategoryADalay') ?? 0);
      });
      categoryBDelay = await widget.controller.prefs.then((SharedPreferences prefs) {
        return (prefs.getInt('CategoryBDalay') ?? 3);
      });
      categoryCDelay = await widget.controller.prefs.then((SharedPreferences prefs) {
        return (prefs.getInt('CategoryCDalay') ?? 10);
      });
      categoryDDelay = await widget.controller.prefs.then((SharedPreferences prefs) {
        return (prefs.getInt('CategoryDDalay') ?? 120);
      });
    }


    @override
    initState() {
      super.initState();
      // getSettings();

      // _color = Theme.of(context).scaffoldBackgroundColor;
      myBanner = BannerAd(
        // adUnitId: 'ca-app-pub-3940256099942544/6300978111',
        // adUnitId: 'ca-app-pub-5030843222424346/3066642380',
        adUnitId: 'ca-app-pub-5030843222424346/3066642380',
        size: AdSize.banner,
        request: AdRequest(),
        listener: listener,
      );
      myBanner.load();
      // Load ads.
      adWidget = AdWidget(ad: myBanner);
    }

    void selectDestination(int index) {
      setState(() {
        _selectedDestination = index;
      });
    }

    @override
    Widget build(BuildContext context) {
      _color = Theme.of(context).scaffoldBackgroundColor;
      print(" build(BuildContext context)");
      getSettings();

      var newFormat = DateFormat("jm");
      newFormat = DateFormat("Hm");

      dateNow =
          "${monthStrings[now.add(Duration(days: categoryADelay)).month]}  ${now.add(Duration(days: categoryADelay)).day}, ${now.add(Duration(days: categoryADelay)).year} at " +
              newFormat.format(now.add(Duration(days: categoryADelay)));

      dateNowPlus3 =
          "${monthStrings[now.add(Duration(days: categoryBDelay)).month]}  ${now.add(Duration(days: categoryBDelay)).day}, ${now.add(Duration(days: categoryBDelay)).year} at " +
              newFormat.format(now.add(Duration(days: categoryBDelay)));

      dateNowPlus10 =
          "${monthStrings[now.add(Duration(days: categoryCDelay)).month]}  ${now.add(Duration(days: categoryCDelay)).day}, ${now.add(Duration(days: categoryCDelay)).year} at " +
              newFormat.format(now.add(Duration(days: categoryCDelay)));

      dateNowPlus120 =
          "${monthStrings[now.add(Duration(days: categoryDDelay)).month]}  ${now.add(Duration(days: categoryDDelay)).day}, ${now.add(Duration(days: categoryDDelay)).year} at " +
              newFormat.format(now.add(Duration(days: categoryDDelay)));

      final theme = Theme.of(context);
      final textTheme = theme.textTheme;

      return Scaffold(
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 26.0, horizontal: 16),
                child: Text(
                  'MEL calculator',
                  style: textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Customize categories',
                ),
              ),
              ListTile(
                trailing: IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    widget.controller.updateCategoryDelay("CategoryADalay", categoryADelay);

                  },
                ),
                title: TextFormField(
                  initialValue: categoryADelay.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    categoryADelay = int.parse(text);
                  },
                  decoration: InputDecoration(
                    labelText: 'Category A',
                    border: OutlineInputBorder(),
                  ),
                ),
                // selected: _selectedDestination == 0,
                //onTap: () => selectDestination(0),
              ),
              ListTile(
                trailing: IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    widget.controller.updateCategoryDelay("CategoryBDalay", categoryBDelay);
                  },
                ),
                title: TextFormField(
                  initialValue: categoryBDelay.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    categoryBDelay = int.parse(text);
                  },
                  decoration: InputDecoration(
                    labelText: 'Category B',
                    border: OutlineInputBorder(),
                  ),
                ),
                // selected: _selectedDestination == 0,
                //onTap: () => selectDestination(0),
              ),
              ListTile(
                trailing: IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    widget.controller.updateCategoryDelay("CategoryCDalay", categoryCDelay);
                  },
                ),
                title: TextFormField(
                  onChanged: (text) {
                    categoryCDelay = int.parse(text);
                  },
                  initialValue: categoryCDelay.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Category C',
                    border: OutlineInputBorder(),
                  ),
                ),
                // selected: _selectedDestination == 0,
                //onTap: () => selectDestination(0),
              ),
              ListTile(
                trailing: IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    widget.controller.updateCategoryDelay("CategoryDDalay", categoryDDelay);
                  },
                ),
                title: TextFormField(
                  onChanged: (text) {
                    categoryDDelay = int.parse(text);
                  },
                  initialValue: categoryDDelay.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Category D',
                    border: OutlineInputBorder(),
                  ),
                ),
                // selected: _selectedDestination == 0,
                //onTap: () => selectDestination(0),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Time format',
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: const Text('12'),
                      leading: Radio<TimeType>(
                        value: TimeType.t12,
                        groupValue: _character,
                        onChanged: (TimeType? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('24'),
                      leading: Radio<TimeType>(
                        value: TimeType.t24,
                        groupValue: _character,
                        onChanged: (TimeType? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text('MEL calculator'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SizedBox.expand(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        showedData(),
                        adBuner(),
                        infoForUser(),
                      ],
                    ),
                  ),
                  themeButtons(context),
                ],
              ),
            ),
          ),
        ),
      );
    }

    ListView drawerMenu(TextTheme textTheme) {
      return ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 26.0, horizontal: 16),
            child: Text(
              'MEL calculator',
              style: textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Customize categories',
            ),
          ),
          ListTile(
            trailing: IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                widget.controller.updateCategoryDelay("CategoryADalay", categoryADelay);

              },
            ),
            title: TextFormField(
              initialValue: categoryADelay.toString(),
              keyboardType: TextInputType.number,
              onChanged: (text) {
                categoryADelay = int.parse(text);
              },
              decoration: InputDecoration(
                labelText: 'Category A',
                border: OutlineInputBorder(),
              ),
            ),
            // selected: _selectedDestination == 0,
            //onTap: () => selectDestination(0),
          ),
          ListTile(
            trailing: IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                widget.controller.updateCategoryDelay("CategoryBDalay", categoryBDelay);
              },
            ),
            title: TextFormField(
              initialValue: categoryBDelay.toString(),
              keyboardType: TextInputType.number,
              onChanged: (text) {
                categoryBDelay = int.parse(text);
              },
              decoration: InputDecoration(
                labelText: 'Category B',
                border: OutlineInputBorder(),
              ),
            ),
            // selected: _selectedDestination == 0,
            //onTap: () => selectDestination(0),
          ),
          ListTile(
            trailing: IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                widget.controller.updateCategoryDelay("CategoryCDalay", categoryCDelay);
              },
            ),
            title: TextFormField(
              onChanged: (text) {
                categoryCDelay = int.parse(text);
              },
              initialValue: categoryCDelay.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Category C',
                border: OutlineInputBorder(),
              ),
            ),
            // selected: _selectedDestination == 0,
            //onTap: () => selectDestination(0),
          ),
          ListTile(
            trailing: IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                widget.controller.updateCategoryDelay("CategoryDDalay", categoryDDelay);
              },
            ),
            title: TextFormField(
              onChanged: (text) {
                categoryDDelay = int.parse(text);
              },
              initialValue: categoryDDelay.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Category D',
                border: OutlineInputBorder(),
              ),
            ),
            // selected: _selectedDestination == 0,
            //onTap: () => selectDestination(0),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Time format',
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  title: const Text('12'),
                  leading: Radio<TimeType>(
                    value: TimeType.t12,
                    groupValue: _character,
                    onChanged: (TimeType? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text('24'),
                  leading: Radio<TimeType>(
                    value: TimeType.t24,
                    groupValue: _character,
                    onChanged: (TimeType? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    Stack infoForUser() {
      return Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            //height: 200,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border:
              Border.all(color: Color.fromARGB(255, 51, 204, 255), width: 1),
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Calculates the UTC dates from today for ICAO MEL limitations",
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              left: 50,
              top: 12,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: _color,
                ),
                child: Text(
                  'Info',
                  style: TextStyle(fontSize: 12),
                ),
              )),
        ],
      );
    }

    Container adBuner() {
      return Container(
        alignment: Alignment.center,
        child: adWidget,
        color: Colors.blue,
        width: myBanner.size.width.toDouble(),
        height: myBanner.size.height.toDouble(),
      );
    }

    Stack showedData() {
      return Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            //height: 200,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border:
              Border.all(color: Color.fromARGB(255, 51, 204, 255), width: 1),
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$dateNow",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Category A ($categoryADelay days)",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "$dateNowPlus3",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Category B ($categoryBDelay days)",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "$dateNowPlus10",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Category C ($categoryCDelay days)",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "$dateNowPlus120",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Category D ($categoryDDelay days)",
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              left: 50,
              top: 12,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                //color: AdaptiveTheme.of(context).theme.scaffoldBackgroundColor,
                decoration: BoxDecoration(
                  color: _color,
                ),

                child: Text(
                  'Aircraft on ground',
                  style: TextStyle(fontSize: 12),
                ),
              )),
        ],
      );
    }

    Row themeButtons(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // AdaptiveTheme.of(context).setDark();
              // setState(() {
              //   _color = AdaptiveTheme.of(context).theme.scaffoldBackgroundColor;
              // });
            },
            style: ElevatedButton.styleFrom(
              visualDensity: VisualDensity(horizontal: 4, vertical: 2),
            ),
            child: Text('Dark theme'),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              // AdaptiveTheme.of(context).setLight();
              // setState(() {
              //   _color = AdaptiveTheme.of(context).theme.scaffoldBackgroundColor;
              // });
            },
            child: Text('Light theme'),
            style: ElevatedButton.styleFrom(
              visualDensity: VisualDensity(horizontal: 4, vertical: 2),
            ),
          ),
        ],
      );
    }


}
