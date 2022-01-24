import 'dart:io';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:hive/hive.dart';

class UserAgentService {


  static Future initUserAgent() async {
    var box = Hive.box('session');

    await FkUserAgent.init();
    String userAgent = FkUserAgent.userAgent ?? '';
    String name = await FkUserAgent.getPropertyAsync('applicationName') ?? '';
    String version = await FkUserAgent.getPropertyAsync('applicationVersion')  ?? '';
    dynamic build;

    if (Platform.isAndroid) {
      build = await FkUserAgent.getPropertyAsync('applicationBuildNumber');
    } else if (Platform.isIOS) {
      build = await FkUserAgent.getPropertyAsync('buildNumber');
    }
    

    box.put('userAgent', name + '/' + version + 'rc' + '/' + (build.toString()) + ' ' + userAgent);
    // box.put('userAgent', name + '/' + version  + '/' + (build.toString()) + ' ' + userAgent);
  }



  static String? getUserAgent() {
    var box = Hive.box('session');
    return box.get('userAgent');
  }

}