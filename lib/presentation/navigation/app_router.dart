import 'package:fluro/fluro.dart';
import 'package:lseway/presentation/navigation/main_router.dart';
import 'package:lseway/presentation/screens/CinfrimEmailScreen/confrim_email_screen.dart';
import 'package:lseway/presentation/screens/EditEmailScreen/edit_email_screen.dart';
import 'package:lseway/presentation/screens/EditNameScreen/edit_name_screen.dart';
import 'package:lseway/presentation/screens/EmailChangeSuccess/email_change_success.dart';
import 'package:lseway/presentation/screens/MainScreen/MapScreen/map_screen.dart';
import 'package:lseway/presentation/screens/MainScreen/ProfileScreen/profile_screen.dart';
import 'package:lseway/presentation/screens/SettingsScreens/OrderHistoryScreen/order_history_screen.dart';
import 'package:lseway/presentation/screens/SettingsScreens/PaymentMethodsScreen/payment_methods_screen.dart';
import 'package:lseway/presentation/screens/SettingsScreens/SupportScreen/support_screen.dart';
import 'package:lseway/presentation/screens/SettingsScreens/TopPlacesScreen/top_places_screen.dart';

class AppRouter {
  static FluroRouter router = FluroRouter();

  static final Handler _mapHandler =
      Handler(handlerFunc: (context, pwarameters) => const MapScreen());


  static final Handler _profileHandler =
      Handler(handlerFunc: (context, pwarameters) => const ProfileScreen());

              static final Handler _nameChangeHandler =
      Handler(handlerFunc: (context, pwarameters) => const EditNameScreen());

        static final Handler _emailChangeHandler =
      Handler(handlerFunc: (context, pwarameters) => const EditEmailScreen());

        static final Handler _emailCodeHandler =
      Handler(handlerFunc: (context, pwarameters) {
        
       return  ConfrimEmailScreen();
      }

        );
              static final Handler _emailChangeSuccessHandler =
      Handler(handlerFunc: (context, pwarameters) => const EmailChangeSuccessScreen());

static final Handler _orderHistoryHandler =
      Handler(handlerFunc: (context, pwarameters) => const OrderHistoryScreen());

static final Handler _topPlacesHandler =
      Handler(handlerFunc: (context, pwarameters) => const TopPlacesScreen());


static final Handler _supportHandler =
      Handler(handlerFunc: (context, pwarameters) => const SupportScreen());


      
static final Handler _paymentMethodsHandler =
      Handler(handlerFunc: (context, pwarameters) => const PaymentMethodsScreen());






  static void setupRouter() {
    router.define('/', handler: _mapHandler);
    router.define('/profile', handler: _profileHandler);
    router.define('/email', handler: _emailChangeHandler);
    router.define('/email/code', handler: _emailCodeHandler);
    router.define('/email/success', handler: _emailChangeSuccessHandler);
    router.define('/name', handler: _nameChangeHandler);
    router.define('/history', handler: _orderHistoryHandler);
    router.define('/topPlaces', handler: _topPlacesHandler);
    router.define('/support', handler: _supportHandler);
    router.define('/paymentMethods', handler: _paymentMethodsHandler);

  }
}
