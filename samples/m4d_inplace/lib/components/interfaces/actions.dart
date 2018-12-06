/*
 * Copyright (c) 2016, Michael Mitterer (office@mikemitterer.at),
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

library m4d_inplace_sample.components.interfaces.actions;

import 'package:m4d_flux/m4d_flux.dart';

import 'package:m4d_inplace_sample/model.dart';

/// If the Timer updates our views we make the update-action more
/// specific to optimize things a bit.
///
///     // in store
///     emitChange(action: new UpdateTimeView());
///
///     // in component
///
///
class UpdateTimeView extends Action implements UpdateView {
    static const ActionName NAME = const ActionName("mdl_inplace_edit_sample.components.interfaces.actions.UpdateTimeView");
    const UpdateTimeView() : super(ActionType.Signal,NAME);
}

class PersonChangedAction extends DataAction<Person> {
    static const ActionName NAME = const ActionName("mdl_inplace_edit_sample.components.interfaces.actions.PersonChangedActions");
    const PersonChangedAction(final Person data) : super(NAME,data);
}