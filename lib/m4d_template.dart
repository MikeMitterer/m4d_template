/*
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 * 
 * All Rights Reserved.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/// Support for doing something awesome.
///
/// More dartdocs go here.
library m4d_template;

import 'dart:html' as dom;
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

//import 'package:mdl/mustache.dart';


import 'package:m4d_core/m4d_core.dart';
import "package:m4d_core/m4d_ioc.dart" as ioc;
import 'package:m4d_directive/directive/components/interfaces/actions.dart';
import 'package:m4d_directive/directive/components/interfaces/stores.dart';
import 'package:m4d_directive/services.dart' as directiveService;
import 'package:m4d_flux/m4d_flux.dart';

part "template/components/M4DListComponent.dart";
part "template/components/MdlTemplateComponent.dart";

part "template/interfaces.dart";

part "template/modules/Renderer.dart";
part "template/modules/EventCompiler.dart";
part "template/modules/TemplateRenderer.dart";

//part "template/modules/ListRenderer.dart";

//class MdlTemplateModule extends Module {
//    configure() {
//        bind(TemplateRenderer);
//        bind(ListRenderer);
//    }
//}
//final MdlTemplateModule _templateModule = new MdlTemplateModule();

//void registerMdlTemplateComponents() {
//
//    registerMaterialMustache();
//    registerMaterialRepeat();
//
//    //componentHandler().addModule(_templateModule);
//}

void registerM4DTemplateComponents() {
    registerM4DListComponent();
}

class TemplateModule extends ioc.IOCModule {

    @override
    configure() {
        registerM4DTemplateComponents();
    }
}