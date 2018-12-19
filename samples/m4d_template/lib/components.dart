/*
 * Copyright (c) 2018, Michael Mitterer (office@mikemitterer.at),
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

library m4d_todo_sample.components;

import "dart:html" as dom;
import "dart:async";

import 'package:logging/logging.dart';

import 'package:m4d_core/m4d_core.dart';
import 'package:m4d_core/m4d_ioc.dart' as ioc;

import "package:m4d_components/m4d_components.dart";
import "package:m4d_directive/m4d_directive.dart";
import "package:m4d_directive/services.dart" as directiveService;
import 'package:m4d_template/m4d_template.dart';

import 'services.dart';
import 'components/interfaces/stores.dart';
import 'datastore.dart';

part "components/ToDoListComponent.dart";
part "components/ToDoInputComponent.dart";

void registerToDoComponents() {
    registerToDoListComponent();
    registerToDoInputComponent();
}

class ToDoExampleModule extends ioc.Module {
    // One instance for SimpleDataStore and for SimpleValueStoree
    final _store = ToDoDataStore();

    @override
    configure() {
        registerToDoComponents();

        ioc.Container().bind(ToDoInputStore).to(_store);
        ioc.Container().bind(ToDoListStore).to(_store);

        // Stores for mdl_model, mdl_attribute, mdl_class
        ioc.Container().bind(directiveService.SimpleDataStore).to(_store);
        ioc.Container().bind(directiveService.SimpleValueStore).to(_store);

    }

    @override
    List<ioc.Module> get dependsOn => [
        CoreComponentsModule(),
        DirectivesModule()
    ];
}