module.exports = class Vm extends require('./vm_abstract')

  getMainViewClass: ->
    require('./views/main_view')