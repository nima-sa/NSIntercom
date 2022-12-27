import 'package:flutter/material.dart';
import 'package:intercom/NS_Lib/NSStorage.dart';
import 'package:intercom/NS_Lib/NSToast.dart';
import 'package:intercom/SocketHandler.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SocketHandler handler;
  bool devConnected = false;
  bool appConnected = false;
  String devID = '';
  String appID = '';
  bool showsDevID = false;

  int openDoorInterval = 10;

  TextEditingController devIDController = TextEditingController();
  TextEditingController appIDController = TextEditingController();
  TextEditingController intervalController = TextEditingController();

  FocusNode devIDFocus = FocusNode();
  FocusNode appIDFocus = FocusNode();
  FocusNode intervalFocus = FocusNode();

  void onAppConnect(bool appConnect, bool devIDValid) {
    setState(() => appConnected = appConnect);
  }

  void buildSocket() {
    handler = SocketHandler(
      appID: appID,
      devID: devID,
      devEvent: (e) {
        setState(() => devConnected = true);

        NSToast.warningText(e['message'] ?? 'Unknown message from chip')
            .show(context);
      },
      onAppConnect: onAppConnect,
      onDevConnect: (c) => setState(() => devConnected = c),
      devResponse: (k) {
        setState(() => devConnected = true);
        final appID = k['appID'] ?? '';
        if (appID == '' || appID == this.appID)
          NSToast.successIcon(Icons.check).show(context);
        else {
          NSToast.other(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Request origin: ' +
                        appID +
                        '\n' +
                        'message: ' +
                        k['message'] ??
                    ''),
                Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ],
            ),
            backgroundColor: Colors.green,
          ).show(context);
        }
      },
      devStatusUpdate: (k) {
        NSToast.successIcon(Icons.check).show(context);
        print(k);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    devID = NSStorage.recallCached(key: 'devID');
    appID = NSStorage.recallCached(key: 'appID');
    devIDController.text = devID ?? '';
    appIDController.text = appID ?? '';
    intervalController.text = openDoorInterval.toString();
    if (devID != null) buildSocket();
  }

  void setInterval() {
    openDoorInterval = (intervalController.text == ''
        ? 10
        : int.parse(intervalController.text));
    setState(() => intervalController.text = openDoorInterval.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Intercom'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.replay_outlined),
          onPressed: () {
            if (appConnected)
              handler.findDeviceIfNotOnline();
            else
              buildSocket();
          },
        ),
        actions: [
          Icon(
            devConnected ? Icons.link : Icons.link_off,
            color: devConnected ? Colors.white : Colors.red,
          ),
          SizedBox(width: 16),
          Icon(
            appConnected ? Icons.wifi : Icons.wifi_off,
            color: appConnected ? Colors.white : Colors.red,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragEnd: (e) {
            devIDFocus.unfocus();
            appIDFocus.unfocus();
            intervalFocus.unfocus();
            setInterval();
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      TextField(
                        controller: devIDController,
                        focusNode: devIDFocus,
                        obscureText: !showsDevID,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(right: 48),
                          hintText: 'device id',
                        ),
                        onEditingComplete: () {
                          devID = devIDController.text;
                          onAppConnect(false, false);
                          NSStorage.memorise(key: 'devID', value: devID);
                          if (devID != '' || devID != null) {
                            handler.disconnect();
                            buildSocket();
                          }
                          devIDFocus.unfocus();
                        },
                      ),
                      Positioned(
                        child: GestureDetector(
                          child: Icon(Icons.remove_red_eye),
                          onTap: () {
                            setState(() => showsDevID = !showsDevID);
                          },
                        ),
                        right: 8,
                        bottom: 8,
                        top: 8,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: appIDController,
                    focusNode: appIDFocus,
                    decoration: InputDecoration(
                      hintText: 'application id',
                    ),
                    onEditingComplete: () {
                      appIDFocus.unfocus();
                      appID = appIDController.text;
                      NSStorage.memorise(key: 'appID', value: appID);
                      if (devID != '' || devID != null) buildSocket();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Interval: '),
                      Expanded(
                        child: TextField(
                          controller: intervalController,
                          focusNode: intervalFocus,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(right: 48),
                          ),
                          onEditingComplete: () {
                            intervalFocus.unfocus();
                            setInterval();
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        onLongPress: () {
                          openWith(openDoorInterval);
                        },
                        child: Text('Open'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(height: 200, child: buttons()),
                // Spacer(),

                Padding(
                  padding: EdgeInsets.all(4),
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (appConnected)
                          handler.sendForWidget('1', 'cancel_btn');
                        else
                          NSToast.errorIcon(Icons.wifi_off_outlined)
                              .show(context);
                      },
                      child: Text(
                        'Cancel',
                        // style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                    ),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openWith(int interv) {
    if (appConnected)
      handler.sendForWidget(interv.toString(), 'open_btn');
    else
      NSToast.errorIcon(Icons.wifi_off_outlined).show(context);
  }

  Widget buttons() {
    List<Widget> nums = [];
    List<int> preLoadedNums =
        [1, 2, 3] + List.generate(25, (index) => index * 5).skip(1).toList();
    // preLoadedNums.skip(0).toList();
    for (int i = 0; i < preLoadedNums.length; i++) {
      final num = preLoadedNums[i];
      final _sec = num % 60 >= 10 ? '${num % 60}' : '0${num % 60}';
      final t = num < 60 ? num.toString() : '${num ~/ 60}:$_sec';
      nums.add(
        Padding(
          padding: EdgeInsets.all(4),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: Text(
              t,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {},
            onLongPress: () {
              openWith(num);
            },
          ),
        ),
      );
    }
    return CustomScrollView(
      scrollDirection: Axis.horizontal,
      slivers: [
        SliverGrid.count(
          // childAspectRatio: (1 / 1.5),
          crossAxisCount: 3,
          children: nums,
        )
      ],
    );
  }
}
