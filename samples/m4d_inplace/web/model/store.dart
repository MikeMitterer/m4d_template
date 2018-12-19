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

library app.model;

import "dart:async";
import 'package:intl/intl.dart';

import 'package:console_log_handler/console_log_handler.dart';
import 'package:validate/validate.dart';

import 'package:m4d_core/m4d_ioc.dart' as ioc;

import 'package:m4d_flux/m4d_flux.dart';
import 'package:m4d_directive/m4d_directive.dart';
import 'package:m4d_directive/services.dart' as directiveServices;
import 'package:m4d_template/m4d_template.dart';

import "package:m4d_inplace_sample/components/interfaces/actions.dart";
import "package:m4d_inplace_sample/components/interfaces/stores.dart";
import 'package:m4d_inplace_sample/services.dart' as inplaceServices;
import "package:m4d_inplace_sample/m4d_inplace_sample.dart" show Person;

/// Concrete implementation for our stores.
///
/// We could use two separate implementations for each store but as you can see here,
/// for simplicity we use one store for the whole Application
class PersonsStoreImpl extends Dispatcher with SimpleDataStoreMixin implements PersonsStore {
    final Logger _logger = new Logger('m4d_inplace_sample.stores.PersonsStoreImpl');

    PersonsStoreImpl() : super(ActionBus()) {
        _logger.info("PersonsStoreImpl - CTOR");

        prop<List<PersonForList>>("persons").value = List<PersonForList>();

        _initSampleData();
        _bindSignals();
        _bindActions();
        _initTimer();
    }

    //- public interfaces -------------------------------------------------------------------------

    List<Person> get persons => prop<List<PersonForList>>("persons").value;

    /// Returns a NEW [Person] object - we don't want
    /// to modify Store-Objects directly!
    Person byId(final String uuid) {
        Validate.isUUID(uuid);
        return new Person.from(_byId(uuid));
    }

    String get time {
        return new DateFormat.Hms().format(new DateTime.now());
    }

    //- private -----------------------------------------------------------------------------------

    void _bindActions() {
        on(PersonChangedAction.NAME)
            .map((final Action action) => action as PersonChangedAction)
            .listen((final PersonChangedAction action) {

            final Person newPerson = action.data;
            final Person oldPerson = _byId(newPerson.id);

            oldPerson.update(newPerson);
            emitChange();
        });
    }

    /// Internal [Person] object - can be modified
    Person _byId(final String uuid) {
        Validate.isUUID(uuid);
        return persons.firstWhere((final Person person) => person.id == uuid);
    }

    void _bindSignals() {
    }

    void _initSampleData() {
        persons.add(new PersonForList("Marilyn","Monroe",36, """
            Marilyn Monroe (1926-1962) Model, actress, singer and arguably
            one of the most famous women of the twentieth century.
        """.trim().replaceAll(new RegExp(r"\s+")," ")));

        persons.add(new PersonForList("Abraham","Lincoln",56, """
            Abraham Lincoln was born Feb 12, 1809, in Hardin Country, Kentucky.
            His family upbringing was modest; his parents from Virginia were neither wealthy or well known.
            At an early age, the young lincolnAbraham lost his mother and his father moved away to Indiana.
        """.trim().replaceAll(new RegExp(r"\s+")," ")));

        persons.add(new PersonForList("Agnes","Gonxha Bojaxhiu",87, """
            Mother Teresa (1910-1997) was a Roman Catholic nun, who devoted her life to serving
            the poor and destitute around the world. She spent many years in Calcutta,
            India where shed founded the Missionaries of Charity, a religious congregation
            devoted to helping those in great need.
        """.trim().replaceAll(new RegExp(r"\s+")," ")));
    }

    /// For demonstration purpose - pump update-messages to the
    /// attached stores
    void _initTimer() {
        new Timer.periodic(new Duration(seconds: 1), (_) => emitChange(action: new UpdateTimeView()));
    }
}

class InplaceStoreModule extends ioc.Module {
    final _store = PersonsStoreImpl();

    @override
    configure() {
        ioc.Container().bind(inplaceServices.PersonsStore).to(_store);
        ioc.Container().bind(directiveServices.SimpleValueStore).to(_store);
    }
}

/// m4d-list component asks for "id" and for this give it to the component this way
///
///     <m4d-list model="persons">
///         <template>
///             <sample-inplace-edit class="sample-inplace-edit--shadow" data-id="{{id}}"></sample-inplace-edit>
///         </template>
///     </m4d-list>
///
class PersonForList extends Person implements SimpleDataObject {

    PersonForList(final String firstname,final String lastname, final int age, final String bio)
        : super(firstname, lastname, age, bio);

    @override
    String asString(final String name) {
        if(name == "id") {
            return id;
        }
        throw "asString ist not implemented for ${name}!";
    }

    @override
    bool contains(final String name) {
        if(name == "id") {
            return true;
        }
        throw "contains ist not implemented for ${name}!";
    }
}
