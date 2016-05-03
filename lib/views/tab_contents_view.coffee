module.exports = class TabContentsView extends require('backbone.marionette').CollectionView

  template: false

  childView: require('./tab_content_view')

  initialize: (options) ->
    @cmiTabsContentAttributesOptions = options.cmiTabsContentAttributesOptions

  childViewOptions: =>
    cssClassAttr: @cmiTabsContentAttributesOptions