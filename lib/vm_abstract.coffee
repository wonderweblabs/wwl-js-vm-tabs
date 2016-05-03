_ = require('underscore')

module.exports = class VmAbstract extends require('wwl-js-vm').VM

  stop: ->
    super()

    @_collection.reset() if @_collection
    @_collection = null

  addTab: (attributes) ->
    @getCollection().add(attributes)

  getCollection: ->
    @_collection or= new (require('./collections/tabs_collection'))()

  getMainViewOptions: ->
    _.extend(super(), {
      collection:     @getCollection()
      cmiTabsOptions: @options.cmiTabsOptions || {}
      cmiTabsAttributesOptions: @options.cmiTabsAttributesOptions || {}
    })