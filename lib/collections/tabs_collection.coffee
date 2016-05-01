_ = require('underscore')

module.exports = class TabsCollection extends require('backbone').Collection

  model: require('../models/tab')

  comparator: 'position'

  sync: ->
    # Prevent ajax

  initialize: (models, options) ->
    super(models, options)

    @listenTo @, 'add',     @onAdd
    @listenTo @, 'remove',  @onRemove
    @_listenToChangeActive()
    @_listenToChangePosition()

  setActive: (model) ->
    if model.isDisabled()
      model.set 'active', false
    else
      @each (m) -> m.set('active', m.cid == model.cid)

  onAdd: (model) =>
    if @size() <= 1
      model.set({
        active:   true
        position: 0
      })
    else
      @setActive(model) if model.isActive()
      @_ensureActive()
      @_normalizePositions()

  onRemove: (model) =>
    @_ensureActive()
    @_normalizePositions()

  onChangeActive: (model) =>
    # prevent endless loop
    @_stopListenToChangeActive()

    # set new one active/others inactive and normalize data
    @setActive(model) if model && model.isActive() && !model.isDisabled()
    @_ensureActive()

    # listen again for upcoming changes
    @_listenToChangeActive()

    # separate notifier
    @trigger 'active:change'

  onChangePosition: (model) =>
    @_shiftFollowingPositions(model)
    @_normalizePositions()


  # ---------------------------------------------
  # private

  # @nodoc
  _listenToChangeActive: ->
    @listenTo @, 'change:active', @onChangeActive

  # @nodoc
  _stopListenToChangeActive: ->
    @stopListening @, 'change:active'

  # @nodoc
  _listenToChangePosition: ->
    @listenTo @, 'change:position', @onChangePosition

  # @nodoc
  _stopListenToChangePosition: ->
    @stopListening @, 'change:position'

  # @nodoc
  _ensureActive: ->
    # If there is one active and not disabled, everything is fine
    activeTabs = @where({ active: true }) || []
    return if _.size(activeTabs) == 1 && _.first(activeTabs).isDisabled() == false

    # Deactivate all disabled
    _.each (@where({ disabled: true }) || []), (t) -> t.set('active', false)

    # Ensure one active
    activeTabs = @where({ active: true }) || []

    if _.any(activeTabs)
      @setActive(_.first(activeTabs), true)
    else
      notDisabled = @where({ disabled: false }) || []
      @setActive(_.first(notDisabled), true) if _.any(notDisabled)

  # @nodoc
  _shiftFollowingPositions: (tab) ->
    # prevent endless loop
    @_stopListenToChangePosition()

    # shift
    @each (t) ->
      return if t == tab
      return if t.get('position') < tab.get('position')

      t.set('position', t.get('position') + 1)

    # listen again for upcoming changes
    @_listenToChangePosition()

  # @nodoc
  _normalizePositions: ->
    # prevent endless loop
    @_stopListenToChangePosition()

    # Replace -1 values
    offset = _.max(@map((t) -> t.get('position'))) || 0
    offset += 1 # adding +1 to ensure another change event at normalize below
    _.each (@where({ position: -1 }) || []), (t, i) -> t.set('position', i + offset, { silent: true })

    # normalize - set values
    @sort().each (t, i) -> t.set 'position', i

    # listen again for upcoming changes
    @_listenToChangePosition()

    # separate notifier
    @trigger 'positions:change'


