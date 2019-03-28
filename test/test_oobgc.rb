require 'minitest/autorun'
require 'gctools/oobgc'
require 'json'

class TestOOBGC < Minitest::Test

  def test_is_lifecycled
    assert_equal false, GC::OOB.setup?
    assert_equal true, GC::OOB.setup
    assert_equal true, GC::OOB.setup?
    assert_equal true, GC::OOB.setup
    assert_equal true, GC::OOB.setup?
    assert_equal true, GC::OOB.teardown
    assert_equal false, GC::OOB.setup?
    assert_equal true, GC::OOB.teardown
    assert_equal false, GC::OOB.setup?
  end

  def test_run_returns_false_when_not_setup
    assert_equal false, GC::OOB.setup?
    assert_equal false, GC::OOB.run
  end
  
  def test_oob_sweep
    assert_equal true, GC::OOB.setup
    GC::OOB.clear
    GC.start
    150_000.times{ Object.new }
    GC.start(immediate_sweep: false)
    assert_equal false, GC.latest_gc_info(:immediate_sweep)
    150_000.times{ Object.new }
    before = GC::OOB.stat(:sweep_count)
    assert_equal true, GC::OOB.run
    info = GC.latest_gc_info
    assert_operator GC::OOB.stat(:sweep_count), :>, before
  ensure
    assert_equal true, GC::OOB.teardown
  end

  def test_oob_mark
    assert_equal true, GC::OOB.setup
    GC::OOB.clear
    oob = 0
    before = GC.count
    minor = GC.stat(:minor_gc_count)

    20.times do
      5_000.times{ Object.new }
      oob += 1 if GC::OOB.run
    end

    assert_operator oob, :>=, GC::OOB.stat(:minor_count)
    assert_operator GC.stat(:minor_gc_count) - minor - oob + GC::OOB.stat(:major_count), :>=, 0
  ensure
    assert_equal true, GC::OOB.teardown
  end

  def test_oob_major_mark
    assert_equal true, GC::OOB.setup
    GC::OOB.clear
    oob = 0
    before = GC.count
    major = GC.stat(:major_gc_count)
    list = []

    20.times do
      2_000.times do
        list << JSON.parse('{"hello":"world", "foo":["bar","bar"], "zap":{"zap":"zap"}}')
        list.shift if list.size > 2_000
      end
      oob += 1 if GC::OOB.run
    end

    assert_equal oob, GC::OOB.stat(:count)
    major = GC.stat(:major_gc_count) - major
    assert_operator major, :>, 0
    assert_operator GC::OOB.stat(:major_count), :>, 0
  ensure
    assert_equal true, GC::OOB.teardown
  end
end
