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

part of m4d_template;

//typedef void EventCallback([ final param1, final param2, final param3 ]);

abstract class TemplateComponent {

    /// Subclasses must override this getter
    String get template;

    /**
     *  Makes it easy to add functionality to templates
     *  Sample:
     *      Template: "{{lambdas.classes}}, {{lambdas.attributes}}
     *
     *  class MyClass extends Object with TemplateComponent {
     *      MyClass() {
     *          lambdas["classes"] = (_) => "is-enabled";
     *          lambdas["attributes"] = attributes;
     *      }
     *
     *      String get attributes => "disabled";
     *  }
     */
    //final Map<String,LambdaFunction> lambdas = new Map<String,LambdaFunction>();

    /// Provide here all the events your component can handle
    /// 
    ///     @override
    ///     Map<String,Function> get events {
    ///         return <String,Function>{
    ///             "onAdd" : onAdd
    ///         };
    ///     }
    Map<String,Function> get events => <String,Function>{ };
}

/// Needed for M4DListComponent
abstract class SimpleDataObject {
    bool contains(final String name);
    String asString(final String name);
}