import "dart:async";

import 'package:console_log_handler/console_log_handler.dart';

import 'package:m4d_core/m4d_ioc.dart' as ioc;
import 'package:m4d_core/services.dart' as coreService;

import 'package:m4d_core/m4d_core.dart';
import 'package:m4d_flux/m4d_flux.dart';

import "package:m4d_template_sample/components/interfaces/stores.dart";
import "package:m4d_template_sample/components.dart";

class Application implements MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    /// Added by the MDL/Dart-Framework (mdlapplication.dart)
    final _actionbus = ActionBus();

    @override
    void run() {
        Future(() => _bindSignals());
    }

    //- private -----------------------------------------------------------------------------------

    void _bindSignals() {
        // Not necessary - just a demonstration how to listen to the "global" ActionBus
        _actionbus.on(AddItemAction.NAME).listen((_) {
            _logger.info("User clicked on 'Add'!");
        });
    }
}

Future main() async {
    // final Logger _logger = new Logger('main.ToDo');

    configLogging();

    ioc.IOCContainer.bindModules([
        ToDoExampleModule()
    ]).bind(coreService.Application).to(Application());

    final Application app = await componentHandler().run();
    app.run();
}

