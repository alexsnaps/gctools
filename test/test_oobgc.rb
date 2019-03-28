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

  # def setup
  #   GC::OOB.setup
  #   GC::OOB.clear
  # end

  # def test_oob_sweep
  #   GC.start(immediate_sweep: false)
  #   assert_equal false, GC.latest_gc_info(:immediate_sweep)

  #   before = GC::OOB.stat(:sweep_count)
  #   while !GC::OOB.run do
  #     GC.start(immediate_sweep: false)
  #     assert_equal false, GC.latest_gc_info(:immediate_sweep)
  #     (rand(250_000)).times{ Object.new }
  #   end
  #   assert_operator GC::OOB.stat(:sweep_count), :>, before
  # end

  # def test_oob_mark
  #   oob = 0
  #   before = GC.count
  #   minor, major = GC.stat(:minor_gc_count), GC.stat(:major_gc_count)

  #   20.times do
  #     (10_000 + rand(25_000)).times{ Object.new }
  #     oob += 1 if GC::OOB.run
  #   end

  #   assert_equal 0, GC.count - before - oob
  #   assert_equal 0, GC.stat(:minor_gc_count) - minor - oob
  #   assert_equal major, GC.stat(:major_gc_count)
  # end

  # def test_oob_major_mark
  #   oob = 0
  #   before = GC.count
  #   minor, major = GC.stat(:minor_gc_count), GC.stat(:major_gc_count)
  #   list = []

  #   20.times do
  #     2_000.times do
  #       list << JSON.parse('{"hello":"world", "foo":["bar","bar"], "zap":{"zap":"zap"}}')
  #       list.shift if list.size > 2_000
  #     end
  #     oob += 1 if GC::OOB.run
  #   end

  #   assert_equal oob, GC::OOB.stat(:count)
  #   minor = GC.stat(:minor_gc_count) - minor
  #   major = GC.stat(:major_gc_count) - major
  #   assert_equal 1, GC.count - before - major - minor - GC::OOB.stat(:sweep_count)
  #   assert_equal 1, GC.count - before - GC::OOB.stat(:major_count) - GC::OOB.stat(:minor_count) - GC::OOB.stat(:sweep_count)
  # end
end
