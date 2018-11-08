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

class TemplateRenderer {
    final Logger _logger = new Logger('mdltemplate.TemplateRenderer');

    /// Adds data to Dom
    final _renderer = DomRenderer();

    /// changes something like data-mdl-click="check({{id}})" into a callable Component function
    final _eventCompiler = EventCompiler();

    /// Defines if new nodes are added to the parent or of the old node will be replaced by
    /// the new one.
    bool appendNewNodes = false;

    Future<void> render(final dom.Element parent,String template(), Map<String,Function> events(),
        { final bool replaceNode: true }) async {

        Validate.notNull(parent);

        /// Trims the template and replaces multiple spaces with a single space
        String _template() {
            final String data = template();
            Validate.notNull(data,"Template for TemplateRenderer must not be null!!!!");

            return data.trim().replaceAll(new RegExp(r"\s+")," ");
        }

        //final Template mustacheTemplate = new Template(_template(),htmlEscapeValues: false);

        final String renderedTemplate = _template(); //mustacheTemplate.renderString(scope);
        final dom.Element child = await _renderer.render(parent,renderedTemplate,replaceNode: replaceNode);

        return _eventCompiler.compileElement(child,events);
    }

    // - private ----------------------------------------------------------------------------------

}