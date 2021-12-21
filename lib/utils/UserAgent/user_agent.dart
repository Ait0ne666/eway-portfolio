import 'dart:io';

import 'package:flutter_user_agentx/flutter_user_agent.dart';
import 'package:hive/hive.dart';

class UserAgentService {


  static Future initUserAgent() async {
    var box = Hive.box('session');

    await FlutterUserAgent.init();
    String userAgent = FlutterUserAgent.userAgent ?? '';
    String name = await FlutterUserAgent.getPropertyAsync('applicationName') ?? '';
    String version = await FlutterUserAgent.getPropertyAsync('applicationVersion')  ?? '';
    dynamic build;

    if (Platform.isAndroid) {
      build = await FlutterUserAgent.getPropertyAsync('applicationBuildNumber');
    } else if (Platform.isIOS) {
      build = await FlutterUserAgent.getPropertyAsync('buildNumber');
    }
    

    // box.put('userAgent', name + '/' + version + 'rc' + '/' + (build.toString()) + ' ' + userAgent);
    box.put('userAgent', name + '/' + version  + '/' + (build.toString()) + ' ' + userAgent);
  }



  static String? getUserAgent() {
    var box = Hive.box('session');
    return box.get('userAgent');
  }

}