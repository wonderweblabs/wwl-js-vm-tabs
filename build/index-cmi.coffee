require('webcomponentsjs/webcomponents')

_           = require 'underscore'
domready    = require 'domready'
wwlContext  = require 'wwl-js-app-context'

domready ->
  tester = new (require('wwl-js-vm')).Tester({

    domElementId: 'wwl-js-vm-tester-container'

    config:
      getDefaultVMConfig: ->
        context: new (wwlContext)({ root: true })
        # cmiTabsOptions:
        #   # noInk: true
        #   # noBar: true
        #   # noSlide: true

    vmConfig: _.extend({

      beforeStart: (vm, moduleConfig) ->
        vm.getView().triggerMethod 'attach'
        vm.getView().triggerMethod 'show'

      afterStart: (vm, moduleConfig) ->
        window.vm = vm
        model = window.vm.addTab({
          view: new (require('./test_view'))({ viewModule: vm }),
          title:      'Tab 1'
          position:   0
          errors:     4
          viewClass:  'view-class'
          viewId:     'view-id'
        })

        model.on 'view:beforeRender', ->          console.log 'view:beforeRender'
        model.on 'view:render', ->                console.log 'view:render'
        model.on 'view:beforeAttach', ->          console.log 'view:beforeAttach'
        model.on 'view:attach', ->                console.log 'view:attach'
        model.on 'view:beforeShow', ->            console.log 'view:beforeShow'
        model.on 'view:show', ->                  console.log 'view:show'
        model.on 'view:domRefresh', ->            console.log 'view:domRefresh'
        model.on 'view:beforeDestroy', ->         console.log 'view:beforeDestroy'
        model.on 'view:destroy', ->               console.log 'view:destroy'

        model = window.vm.addTab({
          view: new (require('./test_view'))({ viewModule: vm }),
          title:    'Tab 2'
          position: 10
          errors: 2
        })

        model = window.vm.addTab({
          view: new (require('./test_view'))({ viewModule: vm }),
          title:    'Tab 3'
          position: 20
          disabled: true
          errors: 55
        })

        model = window.vm.addTab({
          view: new (require('./test_view'))({ viewModule: vm }),
          title:    'X'
          active:   true
          position: 1
        })

    }, { vmPrototype: require('../lib/vm_cmi') })

  }).run()
