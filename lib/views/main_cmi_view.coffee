module.exports = class MainCmiView extends require('./main_abstract_view')

  initialize: (options) ->
    super(options)
    @classValue = options.classValue
    @classId = options.idValue

    @.$el.addClass(@classValue)
    @.$el.attr('id', "#{@classId}")

  className: 'wwl-js-vm-tabs wwl-js-vm-tabs-cmi'

  getTabsViewClass: =>
    require('./tabs_cmi_view')
