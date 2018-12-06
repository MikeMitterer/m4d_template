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
     
library m4d_inplace_sample.components;

import 'dart:html' as dom;
import 'dart:async';

import 'package:logging/logging.dart';

import 'package:m4d_core/m4d_core.dart';
import 'package:m4d_flux/m4d_flux.dart';
import 'package:m4d_core/m4d_ioc.dart' as ioc;
import 'package:m4d_animation/m4d_animation.dart';
import 'package:m4d_components/m4d_components.dart';
import 'package:m4d_form/m4d_form.dart';
import 'package:m4d_template/m4d_template.dart';

import 'package:m4d_inplace_sample/model.dart';
import 'package:m4d_inplace_sample/services.dart' as inplaceServices;
import 'package:m4d_inplace_sample/components/interfaces/stores.dart';
import 'package:m4d_inplace_sample/components/interfaces/actions.dart';

export 'package:m4d_inplace_sample/model.dart';

part 'components/NameEditComponent.dart';

final MdlAnimation expandAnimation = new MdlAnimation.keyframes(
    <int, Map<String, Object>>{
        0 : const <String, Object>{
            "margin" : "8px 24px 8px 24px" },

        100 : const <String, Object>{
            "margin" : "24px 4px 24px 4px"}
    });

final MdlAnimation shrinkAnimation = new MdlAnimation.keyframes(
    <int, Map<String, Object>>{
        0 : const <String, Object>{
            "margin" : "24px 4px 24px 4px" },

        100 : const <String, Object>{
            "margin" : "8px 24px 8px 24px"}
    });

final MdlAnimation fadeOut = new MdlAnimation.fromStock(StockAnimation.FadeOut);

void registerInplaceSampleComponents() {
    registerNameEditComponent();
}

class InplaceExampleModule extends ioc.IOCModule {

  @override
  configure() {
      registerInplaceSampleComponents();
  }

  @override
  List<ioc.IOCModule> get dependsOn => [
      CoreComponentsModule(), TemplateModule(), FormModule()
  ];

}