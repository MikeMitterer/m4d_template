library app;
import 'package:console_log_handler/console_log_handler.dart';

import 'package:m4d_core/m4d_ioc.dart' as ioc;
import 'package:m4d_core/services.dart' as coreService;

import 'package:m4d_core/m4d_core.dart';

import 'package:m4d_components/m4d_components.dart';

import "package:m4d_inplace_sample/m4d_inplace_sample.dart";

import 'model/store.dart';

class Application extends MaterialApplication {
    //final Logger _logger = new Logger('main.Application');

    @override
    void run() {

    }

//- private -----------------------------------------------------------------------------------

}

main() async {
    configLogging(show: Level.INFO);

    // Initialize M4D
    ioc.IOCContainer.bindModules([
        InplaceExampleModule(),
        InplaceStoreModule(),
        CoreComponentsModule()
    ]).bind(coreService.Application).to(Application());;

    final MaterialApplication app = await componentHandler().upgrade();
    app.run();
}

