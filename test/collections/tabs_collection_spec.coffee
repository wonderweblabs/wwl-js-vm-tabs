chai    = require('chai')
expect  = chai.expect

describe 'collections/tabs_collection', ->

  TabsCollection = require('../../lib/collections/tabs_collection')

  col   = null
  views = null

  beforeEach ->
    col   = new TabsCollection()
    V     = require('backbone.marionette').LayoutView.extend({ template: '<div></div>' })
    views = [new V(), new V(), new V(), new V()]


  # ------------------------------------------------------------------
  describe 'active state for models', ->

    describe '#add', ->

      # .add({ ... })
      it 'should set first one to active', ->
        col.add({ view: views[0], id: 1 })
        expect(col.get(1).isActive()).to.be.true

        col.reset()

        col.add({ view: views[0], id: 1, active: false })
        expect(col.get(1).isActive()).to.be.true

      # .add({ disabled: true })
      it 'should not set first one to active if disabled:true', ->
        col.add({ view: views[0], id: 1, disabled: true })
        expect(col.get(1).isActive()).to.be.false

      # .add({ ... })
      # .add({ ... })
      it 'should keep active false for second', ->
        col.add({ view: views[0], id: 1 })
        col.add({ view: views[0], id: 2 })
        expect(col.get(1).isActive()).to.be.true
        expect(col.get(2).isActive()).to.be.false

      # .add({ ... })
      # .add({ active: true })
      it 'should set first one to inactive if second is active:true and disabled:false', ->
        col.add({ view: views[0], id: 1 })
        col.add({ view: views[0], id: 2, active: true })
        expect(col.get(1).isActive()).to.be.false
        expect(col.get(2).isActive()).to.be.true

      # .add({ ... })
      # .add({ active: true, disabled: true })
      it 'should keep first one active if second is active:true and disabled:true', ->
        col.add({ view: views[0], id: 1 })
        col.add({ view: views[0], id: 2, active: true, disabled: true })
        expect(col.get(1).isActive()).to.be.true
        expect(col.get(2).isActive()).to.be.false

    describe '#remove', ->

      # [{ id: 1, active: true }, { id: 2, active: false }]
      # .remove(2)
      it 'should keep other states if removed is inactive', ->
        col.add([
          { view: views[0], id: 1 },
          { view: views[0], id: 2 },
        ])
        expect(col.get(1).isActive()).to.be.true
        expect(col.get(2).isActive()).to.be.false

        col.remove(2)
        expect(col.get(1).isActive()).to.be.true

      # [{ id: 1, active: false, disabled: true }, { id: 2, active: false }, { id: 2, active: true }]
      # .remove(3)
      it 'should ensure first not disabled to be active if removed is active', ->
        col.add([
          { view: views[0], id: 1, disabled: true },
          { view: views[0], id: 2 },
          { view: views[0], id: 3, active: true },
        ])
        expect(col.get(1).isActive()).to.be.false
        expect(col.get(2).isActive()).to.be.false
        expect(col.get(3).isActive()).to.be.true

        col.remove(3)
        expect(col.get(1).isActive()).to.be.false
        expect(col.get(2).isActive()).to.be.true

      # [{ id: 1, disabled: true }, { id: 2, active: false }]
      # .remove(2)
      it 'should none set to active if rest is disabled', ->
        col.add([
          { view: views[0], id: 1, disabled: true },
          { view: views[0], id: 2, active: true },
        ])
        expect(col.get(1).isActive()).to.be.false
        expect(col.get(2).isActive()).to.be.true

        col.remove(2)
        expect(col.get(1).isActive()).to.be.false

      it 'should manage multiple changes after each other', ->
        col.add([
          { view: views[0], id: 1, disabled: true },
          { view: views[0], id: 2 },
          { view: views[0], id: 3, active: true },
        ])
        expect(col.get(3).isActive()).to.be.true

        col.get(2).set('active', true)
        expect(col.get(2).isActive()).to.be.true

        col.get(1).set('active', true)
        expect(col.get(2).isActive()).to.be.true

        col.get(2).set('active', false)
        expect(col.get(2).isActive()).to.be.true

        col.get(3).set('active', true)
        expect(col.get(3).isActive()).to.be.true

        col.get(3).set('active', false)
        expect(col.get(2).isActive()).to.be.true

    describe 'on change', ->

      it 'should ensure one is active', ->
        col.add([
          { view: views[0], id: 1, disabled: true },
          { view: views[0], id: 2 },
          { view: views[0], id: 3, active: true },
        ])

        col.get(3).set('active', false)

        expect(col.get(1).isActive()).to.be.false
        expect(col.get(2).isActive()).to.be.true
        expect(col.get(3).isActive()).to.be.false

      it 'should not ensure one is active if all are disabled', ->
        col.add([
          { view: views[0], id: 1, disabled: true },
          { view: views[0], id: 2, disabled: true },
          { view: views[0], id: 3, active: true },
        ])

        col.get(3).set({ active: false, disabled: true })

        expect(col.get(1).isActive()).to.be.false
        expect(col.get(2).isActive()).to.be.false
        expect(col.get(3).isActive()).to.be.false

      it 'should deactivate former active', ->
        col.add([
          { view: views[0], id: 1 },
          { view: views[0], id: 2, active: true },
        ])

        col.get(2).set('active', false)

        expect(col.get(2).isActive()).to.be.false


  # ------------------------------------------------------------------
  describe 'position for models', ->

    describe '#add', ->

      it 'should increment position if no value passed', ->
        col.add([
          { view: views[0], id: 1 },
          { view: views[0], id: 2 },
        ])
        col.add({ view: views[0], id: 3 })

        expect(col.get(1).get('position')).to.eql(0)
        expect(col.get(2).get('position')).to.eql(1)
        expect(col.get(3).get('position')).to.eql(2)

      it 'should normalize position if even if value passed', ->
        col.add([
          { view: views[0], id: 1, position: 10 },
          { view: views[0], id: 2 },
        ])
        col.add({ view: views[0], id: 3, position: 30234 })

        expect(col.get(1).get('position')).to.eql(0)
        expect(col.get(2).get('position')).to.eql(1)
        expect(col.get(3).get('position')).to.eql(2)

      it 'should increment based on last entry', ->
        col.add({ view: views[0], id: 1, position: 30234 })
        col.add({ view: views[0], id: 2, position: 30234 })

        expect(col.get(1).get('position')).to.eql(0)
        expect(col.get(2).get('position')).to.eql(1)

    describe '#remove', ->

      it 'should shift following positions up', ->
        col.add([
          { view: views[0], id: 1 },
          { view: views[0], id: 2 },
          { view: views[0], id: 3 },
        ])

        col.remove(1)

        expect(col.get(2).get('position')).to.eql(0)
        expect(col.get(3).get('position')).to.eql(1)

      it 'should keep positions of items before like they are', ->
        col.add([
          { view: views[0], id: 1 },
          { view: views[0], id: 2 },
          { view: views[0], id: 3 },
        ])

        col.remove(2)

        expect(col.get(1).get('position')).to.eql(0)
        expect(col.get(3).get('position')).to.eql(1)

    describe 'on change', ->

      it 'should insert item at new position', ->
        col.add([
          { view: views[0], id: 1 },
          { view: views[0], id: 2 },
          { view: views[0], id: 3 },
        ])

        col.get(3).set 'position', 1

        expect(col.get(1).get('position')).to.eql(0)
        expect(col.get(3).get('position')).to.eql(1)
        expect(col.get(2).get('position')).to.eql(2)

      it 'should shift all following elements', ->
        col.add([
          { view: views[0], id: 1 },
          { view: views[0], id: 2 },
          { view: views[0], id: 3 },
        ])

        col.get(1).set 'position', 100

        expect(col.get(2).get('position')).to.eql(0)
        expect(col.get(3).get('position')).to.eql(1)
        expect(col.get(1).get('position')).to.eql(2)


