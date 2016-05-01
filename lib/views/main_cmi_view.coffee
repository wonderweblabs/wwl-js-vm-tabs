module.exports = class MainCmiView extends require('./main_abstract_view')

  className: 'wwl-js-vm-tabs wwl-js-vm-tabs-cmi'

  getTabsViewClass: =>
    require('./tabs_cmi_view')

