_ = require('underscore')

module.exports = class TabContentView extends require('backbone.marionette').LayoutView

  template: require('../tpl/tab_content_view.hamlc')

  className: 'tab-content-container'

  regions:
    tabContent: '> .tab-content'

  modelEvents:
    'change:active':    'onChangeActive'
    'change:viewClass': 'onChangeViewClass'
    'change:viewId':    'onChangeViewId'

  onRender: =>
    @getRegion('tabContent').show(@model.get('view'), { preventDestroy: true })

    @_updateCssClasses()
    @_attachTabsAttributes()

  onChangeActive: =>
    @_updateCssClasses()

  onChangeViewClass: (model) =>
    previousClass = model.previousAttributes().viewClass
    @.$el.removeClass(previousClass) if previousClass?

    @_attachTabsAttributes()

  onChangeViewId: =>
    @_attachTabsAttributes()

  # @override
  # @see _clearRegion
  destroy: =>
    @_clearRegion() && super()

  # @override
  # @see _clearRegion
  render: =>
    @_clearRegion() && super()

  # ---------------------------------------------
  # private

  # @nodoc
  _clearRegion: ->
    # Fix for marionette preventDestroy
    #
    # Marionette.Layout is triggering reset on regions,
    # event before onBeforeRender is called.
    # reset calls empty without any arguments so preventDestroy will
    # never work correctly.
    #
    # https://github.com/marionettejs/backbone.marionette/blob/v2.4/src/region.js#L267
    @getRegion('tabContent').empty({ preventDestroy: true }) # if @getRegion('tabContent')

    true

  # @nodoc
  _updateCssClasses: ->
    @.$el.toggleClass('tab-content-container-active', @model.isActive())

  # @nodoc
  _attachTabsAttributes: ->
    @.$el.addClass(@model.get('viewClass'))
    @.$el.attr('id', @model.get('viewId'))
