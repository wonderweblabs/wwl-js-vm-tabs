# WWL VM Tabs

| Current Version | Master | Develop |
|-----------------|--------|---------|
| [![npm version](https://badge.fury.io/js/wwl-js-vm-tabs.svg)](https://badge.fury.io/js/wwl-js-vm-tabs) | [![Build Status](https://travis-ci.org/wonderweblabs/wwl-js-vm-tabs.svg?branch=master)](https://travis-ci.org/wonderweblabs/wwl-js-vm-tabs) | [![Build Status](https://travis-ci.org/wonderweblabs/wwl-js-vm-tabs.svg?branch=develop)](https://travis-ci.org/wonderweblabs/wwl-js-vm-tabs) |

View module ([wwl-js-vm](https://github.com/wonderweblabs/wwl-js-vm)) implementation to maintain tabs view. The implementation is based on [backbone](http://backbonejs.org/) and [backbone.marionette](http://marionettejs.com/).

Each tab requires to get a view object (Backbone.View api compatible) to passed in for each tab model. The model will render that view as content.

---

> **Important** currently (0.1.1), the pure Marionette implementation (without cmi) is still open.

---


## Example

```coffeescript
context = new (require('wwl-js-app-context'))({ root: true })
vm      = new (require('wwl-js-vm-tabs'))({ context: context })

vm.getView().render()
$('body').append(vm.getView().$el)

# Create a dummy content view
View = Backbone.View.extend({ template: '<div><h1>Test</h1></div>' })
view = new View()

# Create a tab
tab = vm.addTab({
  view:   view
  title:  'My first Tab'
  active: true
})

# Listen to your tab

tab.on 'view:render', ->
  # The tab view itself has been rendered
  null


```




## Installation

wwl-js-vm-tabs requires sass, coffeescript, browserify, hamlify.

Make sure, that for sass and for browserify, the load paths are set up correctly.

```sass
// In your applications stylesheet:

// For cmi version:
@import 'wwl-js-vm-tabs/base_cmi'

// For marionette-only version:
@import 'wwl-js-vm-tabs/base_no_cmi'

```


```coffeescript
# In your js application:

# For cmi version:
VmClass = require('wwl-js-vm-tabs')

# For marionette-only version:
VmClass = require('wwl-js-vm-tabs/lib/vm')

```


### Cmi Version

**Important**: To run the cmi version, you need to install webcomponents and link at least:


**TODO** replace with dependencies:

```haml
%link{ rel: "import", href: "../cmi-button/cmi-button.html" }
%link{ rel: "import", href: "../cmi-tabs/cmi-tabs.html" }
```

Unfortunatly, it's not easy to automate this.




## General concept

The tabs stack is maintained by a Backbone.Collection with Backbone.Model instances. Each model represents a tab you can see. A tab model requires at least the attribute ```view``` on initialization.

Every action happening on your tabs view, you can listen to via the model.

There is always one tab with the attribute active:true - the view of the that model will be displayed in the content.




## Tab Model Attributes


| attribute | type | default | description |
|-----------|------|---------|-------------|
| view                | <sup>Backbone.View or same api</sup> | <sup>null</sup> | **required** - The view that will be rendered as content. |
| active              | <sup>boolean</sup> | <sup>false</sup> | If the tab is active (visible). The collection will take care of that there is always just one tab active at the time. |




## Tab Model Events

| event | description |
|-------|-------------|
| view:beforeRender           | Marionette event on the tab item view |
| view:render                 | Marionette event on the tab item view |
| view:beforeAttach           | Marionette event on the tab item view |
| view:attach                 | Marionette event on the tab item view |
| view:beforeShow             | Marionette event on the tab item view |
| view:show                   | Marionette event on the tab item view |
| view:domRefresh             | Marionette event on the tab item view |
| view:beforeDestroy          | Marionette event on the tab item view |
| view:destroy                | Marionette event on the tab item view |
| view:action:activate        | When the tab got active. |
| view:action:deactivate      | When the tab got inactive. |




## With or without cmi webcomponents

By default the tabs are build on base of [curo-material-interface](https://github.com/wonderweblabs/curo-material-interface).

So you'll get the webcomponents implementation if you call:

```coffeescript
require('wwl-js-vm-tabs')
```

Or explicit:

```coffeescript
require('wwl-js-vm-tabs/lib/vm_cmi')
```

If you want to have a marionette-only implementation, you would require the following:

```coffeescript
require('wwl-js-vm-tabs/lib/vm')
```

