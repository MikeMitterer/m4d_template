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
     
part of m4d_todo_sample.components;
 
class ToDoInputComponent extends MdlTemplateComponent {
    final Logger _logger = new Logger('mdl_todo_sample.components.ToDoInputComponent');

//    final nrOfItems = 0;
//    final ObservableProperty<int> nrOfItemsDone = new ObservableProperty<int>(0,
//        interval: new Duration(milliseconds: 1000));

    static const _ToDoInputComponentCssClasses _cssClasses = const _ToDoInputComponentCssClasses();

    final ToDoInputStoreInterface _datastore;

    ToDoInputComponent.fromElement(final dom.HtmlElement element,final ioc.Container iocContainer)
        : _datastore = iocContainer.resolve(ToDoInputStore).as<ToDoInputStoreInterface>(),
            super(element,iocContainer) {
        
        _init();
    }
    
    static ToDoInputComponent widget(final dom.HtmlElement element) => mdlComponent(element,ToDoInputComponent) as ToDoInputComponent;

    
    // - EventHandler -----------------------------------------------------------------------------

    void onAdd() {
        _addItem();
        _logger.fine("Event: onAdd");
    }
    
    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("ToDoInputComponent - init");
        
        /// Recommended - add SELECTOR as class
        element.classes.add(_ToDoInputComponentConstant.WIDGET_SELECTOR);
        
        render().then((_) => _bindSignals());
        
        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    void _bindSignals() {
//        _datastore.onChange.listen((_) {
//            nrOfItems.value = _datastore.nrOfItems;
//            nrOfItemsDone.value = _datastore.nrOfItemsDone;
//        });

        // Listen to Enter
        final item = MaterialTextfield.widget(element.querySelector("#item"));
        item.hub.onKeyDown.listen((final dom.KeyboardEvent event) {
            if(event.keyCode == 13) {
                event.preventDefault();
                event.stopPropagation();
                _addItem();
                item.value = "";
            }
        });

    }

    void _addItem() {
        final MaterialTextfield item = MaterialTextfield.widget(element.querySelector("#item"));
        _datastore.fire(new AddItemAction(new ToDoItem(false,item.value)));
    }

    //- Template -----------------------------------------------------------------------------------
    
    @override
    final String template = """
        <div>
            <div class="mdl-textfield">
                <input id="item" class="mdl-textfield__input" type="text" autofocus />
                <label class="mdl-textfield__label" for="item">Type Something...</label>
            </div>
            <button id="add"
                class="mdl-button mdl-button--raised mdl-button--colored mdl-ripple-effect"
                data-mdl-click="onAdd()">Add</button>

            <span mdl-model="nrOfItemsDone"></span> /
            <span mdl-model="nrOfItems"></span>
        </div>
    """.trim().replaceAll(new RegExp(r"\s+")," ");

   @override
   Map<String,Function> get events {
       return <String,Function>{
           "onAdd" : onAdd
       };
   }
}

/// Registers the ToDoInputComponent-Component
///
///     main() {
///         registerToDoInputComponent();
///         ...
///     }
///
void registerToDoInputComponent() {
    final MdlConfig config = new MdlWidgetConfig<ToDoInputComponent>(
        _ToDoInputComponentConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final ioc.Container iocContainer)
                => new ToDoInputComponent.fromElement(element,iocContainer)
    );
    
    // If you want <todo-input></todo-input> set selectorType to SelectorType.TAG.
    // If you want <div todo-input></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="todo-input"></div>)
    config.selectorType = SelectorType.TAG;
    
    componentHandler().register(config);
}

//- private Classes ----------------------------------------------------------------------------------------------------

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _ToDoInputComponentCssClasses {

    final String IS_UPGRADED = 'is-upgraded';
    
    const _ToDoInputComponentCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _ToDoInputComponentConstant {

    static const String WIDGET_SELECTOR = "todo-input";

    const _ToDoInputComponentConstant();
}    