module.exports = class MainCmiView extends require('./main_abstract_view')

  className: 'wwl-js-vm-tabs wwl-js-vm-tabs-cmi'

  initialize: (options) ->
    super(options)

    @classValue = options.classValue
    @classId    = options.idValue

    @.$el.addClass(@classValue)
    @.$el.attr('id', "#{@classId}")

  getTabsViewClass: =>
    require('./tabs_cmi_view')
