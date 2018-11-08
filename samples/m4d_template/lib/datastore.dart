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

library mdl_todo_sample.datastore;

import 'dart:collection';

import 'package:console_log_handler/console_log_handler.dart';
import 'package:m4d_core/m4d_core.dart';
import 'package:m4d_core/m4d_utils.dart';
import 'package:m4d_directive/directive/components/interfaces/stores.dart';

import 'package:m4d_flux/m4d_flux.dart';

import 'package:m4d_template_sample/components/interfaces/stores.dart';
import 'package:m4d_directive/directive/components/interfaces/stores.dart';

class ToDoDataStore extends Dispatcher
    implements ToDoInputStoreInterface, ToDoListStoreInterface, SimpleValueStore {
    
    final Logger _logger = new Logger('mdl_todo_sample.datastore.ToDoDataStore');

    final List<ToDoItem> _items = new List<ToDoItem>();

    //@protected
    final bindings = Map<String, ObservableProperty>();

    ToDoDataStore() : super(ActionBus()) {
        
        prop("nrOfItemsDone").value = 0;
        prop("nrOfItems").value = 0;

        _bindSignals();
    }

    @override
    int get nrOfItems => ConvertValue.toInt(prop("nrOfItems").value);

    @override
    int get nrOfItemsDone => ConvertValue.toInt(prop("nrOfItemsDone").value);

    UnmodifiableListView<ToDoItem> get items => new UnmodifiableListView<ToDoItem>(_items);

    @override
    bool asBool(final String varname) => bindings.containsKey(varname)
        ? bindings[varname].toBool() : false;

    @override
    bool contains(final String varname) => bindings.containsKey(varname);

    @override
    ObservableProperty<T> prop<T>(final String varname) {
        if(!bindings.containsKey(varname)) {
            bindings[varname] = ObservableProperty<T>(null);
            print("$varname changed...");
            bindings[varname].onChange.listen((_) => emitChange());
        }
        return bindings[varname];
    }

    // - private -------------------------------------------------------------------------------------------------------

    void _bindSignals() {
        on(AddItemAction.NAME)
            .map((final Action action) => action as AddItemAction).listen((final AddItemAction action) {
            _items.add(action.data);
            _logger.info("Add item!");
            _updateProps();
            emitChange(action: ListChangedAction());
        });

        on(ItemCheckedAction.NAME)
            .map((final Action action) => action as ItemCheckedAction).listen((final ItemCheckedAction action) {
            _items.forEach((final ToDoItem item) {
                if(item.id == action.data.id) {
                    item.checked = action.data.checked;
                }
            });
            _updateProps();
        });

        on(RemoveItemAction.NAME)
            .map((final Action action) => action as RemoveItemAction).listen((final RemoveItemAction action) {
            _items.removeWhere((final ToDoItem item) => item.id == action.data.id);
            _updateProps();
            emitChange(action: ListChangedAction());
        });
    }

    void _updateProps() {
        prop("nrOfItems").value = _items.length;
        prop("nrOfItemsDone").value = _items
            .where((final ToDoItem item) => item.checked)
            .length;
    }
}