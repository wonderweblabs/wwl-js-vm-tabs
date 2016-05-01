module.exports = class MainAbstractView extends require('backbone.marionette').LayoutView

  template: require('../tpl/main_view.hamlc')

  regions: ->
    tabs:         '> .tabs'
    tabContents:  '> .tabs-content'

  initialize: (options) ->
    @collection     = options.collection
    @cmiTabsOptions = options.cmiTabsOptions

  getTabsViewClass: =>
    throw 'Implement #getTabsViewClass'

  onRender: =>
    @getRegion('tabs').show(new (@getTabsViewClass())({
      collection:     @collection
      cmiTabsOptions: @cmiTabsOptions
    }))
    @getRegion('tabContents').show(new (require('./tab_contents_view'))({
      collection: @collection
    }))