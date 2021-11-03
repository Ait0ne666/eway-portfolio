import 'dart:io';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo{
  


  NetworkInfoImpl();


  Future<bool> checkConnection()async {
  
          try {
            final result = await InternetAddress.lookup('google.com');

            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                return true;
            } else {
                return false;
            }
        } on SocketException catch(_) {
            return false;
        }
  
  }


  @override
  Future<bool> get isConnected => checkConnection();



  
}