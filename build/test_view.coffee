module.exports = class TestView extends require('backbone.marionette').LayoutView

  template: '#test-view-template'

  className: 'test-view'

  ui:
    placeholder: '.plchldr'

  onRender: =>
    @ui.placeholder.text([
      @cid,
      @getRandText(),
    ].join(' '))

  getRandText: ->
    @_text or= @getText(Math.round(2 * Math.random()))

  getText: (i) ->
    [
      'Aenean a sem nec eros fringilla malesuada nec sed nulla. Morbi vulputate eros et sollicitudin fringilla. Pellentesque eleifend tempor molestie. Nam at massa ex. Sed blandit risus posuere neque viverra auctor. Aliquam in elementum tellus, at consequat lectus. Nunc volutpat turpis non velit dapibus cursus. Vestibulum ut mauris auctor, maximus leo vitae, ultricies purus. Praesent tincidunt bibendum lacinia. Donec sapien lacus, iaculis nec nulla eu, faucibus consequat augue. Quisque at pretium felis. Quisque mollis tortor vel rutrum malesuada.',
      'Donec sed arcu felis. Aliquam.',
      'Vestibulum ut mauris auctor, maximus leo vitae, ultricies purus. Praesent tincidunt bibendum lacinia. Donec sapien lacus, iaculis nec nulla eu, faucibus consequat augue. Quisque at pretium felis. Quisque mollis tortor vel rutrum malesuada.',
    ][i]