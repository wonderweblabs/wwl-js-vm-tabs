_ = require('underscore')

module.exports = class TabsCmiView extends require('backbone.marionette').ItemView

  template: require('../tpl/tabs_cmi_view.hamlc')

  ui:
    tabBar: '> cmi-tabs'
    tabs:   '> cmi-tabs cmi-tab'

  events:
    'click @ui.tabs': 'onTabClick'

  templateHelpers: =>
    getTabs: =>
      @collection.map (t) ->
        id:     t.cid
        name:   t.get('title')

  initialize: (options) ->
    super(options)

    @cmiTabsOptions = _.extend(@getCmiTabsOptionDefaults(), (options.cmiTabsOptions || {}))

    @listenTo @collection, 'update',            @render
    @listenTo @collection, 'reset',             @render
    @listenTo @collection, 'sort',              @render
    @listenTo @collection, 'change:active',     @onChangeActiveOrDisabled
    @listenTo @collection, 'change:disabled',   @onChangeActiveOrDisabled

  onBeforeDestroy: =>
    @_removePolymerElements()

  onBeforeRender: =>
    @_removePolymerElements()

  onRender: =>
    @setCmiTabValues()

  onTabClick: (event) =>
    id = event.currentTarget.getAttribute('data-model-id')
    return unless id

    model = @collection.get(id)
    model.set('active', true) if model

  setCmiTabValues: ->
    return unless _.any(@ui.tabs)

    selectedIndex = -1

    _.each @ui.tabs, (tabDomElement) =>
      tab = @collection.get(tabDomElement.getAttribute('data-model-id'))
      return unless tab

      selectedIndex = @collection.indexOf(tab) if tab.get('active') == true
      tabDomElement.disabled = tab.isDisabled()

    if selectedIndex >= 0 && @ui.tabBar
      HTMLImports.whenReady =>
        domEl = @ui.tabBar[0]

        console.log @cmiTabsOptions
        domEl.selected  = "#{selectedIndex}"
        domEl.noInk     = @cmiTabsOptions.noInk == true
        domEl.noBar     = @cmiTabsOptions.noBar == true
        domEl.noSlide   = @cmiTabsOptions.noSlide == true

  getCmiTabsOptionDefaults: ->
    noInk:    false
    noBar:    false
    noSlide:  false


  # ---------------------------------------------
  # private

  # @nodoc
  _removePolymerElements: ->
    return unless @ui.tabBar && _.any(@ui.tabBar)

    domEl = @ui.tabBar[0]

    domEl.removeOwnKeyBindings() if _.isFunction(domEl.removeOwnKeyBindings)
    domEl.remove() if _.isFunction(domEl.remove)


