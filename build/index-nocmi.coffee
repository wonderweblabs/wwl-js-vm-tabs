require('webcomponentsjs/webcomponents')

global.$                          = require('jquery')
global.jquery                     = global.jQuery = global.$
global._                          = require 'underscore'
global.underscore                 = global._
global.Backbone                   = require 'backbone'
global.backbone                   = global.Backbone
global.Backbone.$                 = $

domready    = require 'domready'
wwlContext  = require 'wwl-js-app-context'

domready ->
  tester = new (require('wwl-js-vm')).Tester({

    domElementId: 'wwl-js-vm-tester-container'

    config:
      getDefaultVMConfig: ->
        context: new (wwlContext)({ root: true })

    vmConfig: _.extend({

      beforeStart: (vm, moduleConfig) ->
        vm.getView().triggerMethod 'attach'
        vm.getView().triggerMethod 'show'

      afterStart: (vm, moduleConfig) ->
        window.vm = vm
        # model = window.vm.addTabs({
        #   view: new (require('./test_view'))({
        #     viewModule: vm
        #   }),
        #   title:            'My Modal'
        #   closeButton:      true
        #   backTopButton:    true
        #   backBottomButton: true
        #   destroyOnClose:   true
        #   cancelButton:     'Cancel'
        #   doneButton:       'Done'
        #   successButton:    'Success'
        # })

        # model.on 'view:beforeRender', ->          console.log 'view:beforeRender'
        # model.on 'view:render', ->                console.log 'view:render'
        # model.on 'view:beforeAttach', ->          console.log 'view:beforeAttach'
        # model.on 'view:attach', ->                console.log 'view:attach'
        # model.on 'view:beforeShow', ->            console.log 'view:beforeShow'
        # model.on 'view:show', ->                  console.log 'view:show'
        # model.on 'view:domRefresh', ->            console.log 'view:domRefresh'
        # model.on 'view:beforeDestroy', ->         console.log 'view:beforeDestroy'
        # model.on 'view:destroy', ->               console.log 'view:destroy'

    }, { vmPrototype: require('../lib/vm') })

  }).run()
