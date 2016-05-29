_ = require('underscore')

module.exports = class Tab extends require('backbone').Model

  defaults:
    title:        ''
    active:       false
    disabled:     false
    position:     -1
    viewId:       null
    viewClass:    null
    view:         null
    errors:       null

  initialize: (attrs, options = {}) ->
    unless attrs.view && _.isObject(attrs.view)
      throw "Tab requires a valid view object as attribute."

  sync: ->
    # Prevent ajax

  isActive: ->
    @get('active') == true

  isDisabled: ->
    @get('disabled') == true

  getTabView: ->
    @_tabView or= null

  setTabView: (view) ->
    @_tabView = view

  resetTabView: ->
    @_tabView = null

  getJqDomContainer: ->
    @getTabView().$el

  onBeforeRender: =>  @trigger 'view:beforeRender', @
  onRender: =>        @trigger 'view:render', @
  onBeforeAttach: =>  @trigger 'view:beforeAttach', @
  onAttach: =>        @trigger 'view:attach', @
  onBeforeShow: =>    @trigger 'view:beforeShow', @
  onShow: =>          @trigger 'view:show', @
  onDomRefresh: =>    @trigger 'view:domRefresh', @
  onBeforeDestroy: => @trigger 'view:beforeDestroy', @
  onDestroy: =>       @trigger 'view:destroy', @

  destroy: (options) =>
    @get('view').destroy() if @get('view')

    super(options)


