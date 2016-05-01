chai    = require('chai')
expect  = chai.expect

describe 'models/tab', ->

  Tab = require('../../lib/models/tab')

  view = null

  beforeEach ->
    V     = require('backbone.marionette').LayoutView.extend({ template: '<div></div>' })
    view  = new V()


  # ------------------------------------------------------------------
  describe '#constructor', ->

    it 'should throw error for missing view instance', ->
      expect(-> new Tab()).to.throw()
      expect(-> new Tab({ view: view })).to.not.throw()


  # ------------------------------------------------------------------
  describe 'defaults', ->

    it 'should have active as false', ->
      t = new Tab({ view: view })
      expect(t.get('active')).to.be.false

    it 'should have disabled as false', ->
      t = new Tab({ view: view })
      expect(t.get('disabled')).to.be.false

    it 'should have position -1', ->
      t = new Tab({ view: view })
      expect(t.get('position')).to.eql(-1)


  # ------------------------------------------------------------------
  describe '#destroy', ->

    it 'should destroy view instance', ->
      t = new Tab({ view: view })
      expect(view.isDestroyed).to.be.false
      t.destroy()
      expect(view.isDestroyed).to.be.true




