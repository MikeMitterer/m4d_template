/**
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

part of m4d_todo_sample.components;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _ToDoListComponentCssClasses {

    static const String MAIN_CLASS  = "todo-list";

    final String IS_UPGRADED = 'is-upgraded';

    const _ToDoListComponentCssClasses();
}

class ModelChangedEvent {
    final ToDoItem item;
    ModelChangedEvent(this.item);
}

class ToDoListComponent extends MdlTemplateComponent {
    final Logger _logger = new Logger('todo.ToDoListComponent');

    static const _ToDoListComponentCssClasses _cssClasses = const _ToDoListComponentCssClasses();

    final ToDoListStoreInterface _datastore;

    ToDoListComponent.fromElement(final dom.HtmlElement element,final ioc.Container iocContainer)
        : _datastore = iocContainer.resolve(ToDoListStore).as<ToDoListStoreInterface>(),
            super(element,iocContainer) {

        _init();
    }

    static ToDoListComponent widget(final dom.HtmlElement element) => mdlComponent(element,ToDoListComponent) as ToDoListComponent;


    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("ToDoItem - init");

        _render().then((_) => _bindSignals() );

        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    void _onRemove(final String id) {
        _logger.info("Remove $id");
        final ToDoItem item = _getItem(id);
        _datastore.fire(new RemoveItemAction(item));
    }

    void _onCheck(final String id, final String elementID) {
        _logger.info("Check $id / $elementID");

        final MaterialCheckbox checkbox = MaterialCheckbox.widget(
            element.querySelector("#${elementID.replaceAll("'", "")}")
        );

        final ToDoItem item = _getItem(id);
        item.checked = checkbox.checked;
        _datastore.fire(new ItemCheckedAction(item));
    }

    ToDoItem _getItem(final String id) {
        return _datastore.items.firstWhere((final ToDoItem item) => item.id == int.parse(id),
            orElse: () => null);
    }

    List<ToDoItem> get _items => _datastore.items;

    Future _render() async {
        Stopwatch stopwatch = new Stopwatch()..start();

        await render();
        stopwatch.stop();

        final String message = "Data rendered with TemplateRenderer (${_items.length}), "
            "took ${stopwatch.elapsedMilliseconds}ms";

        _logger.info(message);
    }

    void _bindSignals() {
        _datastore.onChange.listen((final DataStoreChangedEvent event) {
            // Optimizes rendering
            if(event.data is ListChangedAction) {
                _render();
            }
        });
    }

    //- Template -----------------------------------------------------------------------------------

    @override
    String get template {
        String _allRows() {
            final buffer = StringBuffer();
            _datastore.items.forEach((final ToDoItem item) {
                buffer.write(_row(item));
            });
            return buffer.toString();
        }
        return  """
                <div>
                    ${_allRows()}
                </div>
                """;
    }

    String _row(final ToDoItem item) {
        String _uniqueID() => "${item.id}_${hashCode}";

        return """
            <div class="row">
                <label class="mdl-checkbox mdl-ripple-effect" for="check${_uniqueID()}">
                    <input type="checkbox" 
                        id="check${_uniqueID()}" 
                        class="mdl-checkbox__input" 
                        data-mdl-click="onCheck(${item.id},'check${_uniqueID()}')" 
                        mdl-model="item${item.id}"/>
                    <span class="mdl-checkbox__label">
                        ${item.name.length <= 20 ? item.name : item.name.substring(0,20) + '...'}
                        </span>
                </label>
                <button class="mdl-button mdl-button--colored mdl-ripple-effect"
                    data-mdl-click="onRemove(${item.id})">
                    Remove
                </button>
            </div>
        """;
    }

    @override
    Map<String,Function> get events {
        return <String,Function>{
            "onCheck" : _onCheck,
            "onRemove" : _onRemove,
        };
    }
}

/// registration-Helper
void registerToDoListComponent() {
    final MdlConfig config = new MdlWidgetConfig<ToDoListComponent>(
        _ToDoListComponentCssClasses.MAIN_CLASS,
            (final dom.HtmlElement element, final ioc.Container iocContainer)
                => new ToDoListComponent.fromElement(element, iocContainer));

    config.selectorType = SelectorType.TAG;

    componentHandler().register(config);
}
