require 'big_spoon'

class BigSpoonTest
  hooks do
    before :foo!, :hook_1
  end

  def foo!
    :foo
  end

  def bar!
    :bar
  end

  def i_accept_one(argument)
    puts argument
  end

  def i_accept_many(*arguments)
    puts arguments
  end

  def i_might_accept_one(argument = nil)
    puts argument
  end

  def raise_sommat
    raise "This method will never look the same! EVER!"
  end

  private
  def by_all_means_hook
    true
  end

  def please_dont_hook
    false
  end

  (1..20).each do |index|
    define_method("hook_#{index}") { "hook_#{index}"}
  end
end

describe BigSpoon do
  before :each do
    @big_spoon_test = BigSpoonTest.new
  end

  it "should allow me to add a hook before an object's methods BEFORE THEY EXIST" do
    @big_spoon_test.should_receive(:hook_1)
    @big_spoon_test.foo!
  end

  it "should allow me to add a hook after an object's methods AFTER THEY EXIST" do
    BigSpoonTest.hooks do
      after :bar!, :hook_2
    end
    @big_spoon_test.should_receive(:hook_2)
    @big_spoon_test.bar!
  end

  it "should allow me to add a hook lambda" do
    BigSpoonTest.hooks do
      after :bar! do
        puts self.inspect
      end
    end
    @big_spoon_test.should_receive(:puts)
    @big_spoon_test.should_receive(:inspect)
    @big_spoon_test.bar!
  end

  it "should still return the appropriate method's value" do
    @big_spoon_test.should_receive(:hook_1)
    @big_spoon_test.foo!.should == :foo
  end

  it "should allow me to metaprogram before_* hooks" do
    @big_spoon_test.should_receive(:hook_2)
    BigSpoonTest.hooks do
      before_foo! :hook_2
    end
    @big_spoon_test.foo!
  end

  it "should allow me to metaprogram after_* hooks" do
    @big_spoon_test.should_receive(:hook_3)
    BigSpoonTest.hooks do
      after_foo! :hook_3
    end
    @big_spoon_test.foo!
  end

  it "should let me hook outside of the hooks block" do
    @big_spoon_test.should_receive(:by_all_means_hook)
    BigSpoonTest.before_foo! :by_all_means_hook
    @big_spoon_test.foo!
  end

  it "should not hook if an :if method returns false" do
    @big_spoon_test.should_not_receive(:hook_4)
    BigSpoonTest.before_foo! :hook_4, :if => :please_dont_hook
    @big_spoon_test.foo!
  end

  it "SHOULD hook if an :if method returns true" do
    @big_spoon_test.should_receive(:hook_5)
    BigSpoonTest.before_foo! :hook_5, :if => :by_all_means_hook
    @big_spoon_test.foo!
  end

  it "should not hook if an :unless method returns true" do
    @big_spoon_test.should_not_receive(:hook_6)
    BigSpoonTest.before_foo! :hook_6, :unless => :by_all_means_hook
    @big_spoon_test.foo!
  end

  it "SHOULD hook if an :unless method returns false" do
    @big_spoon_test.should_receive(:hook_7)
    BigSpoonTest.before_foo! :hook_7, :unless => :please_dont_hook
    @big_spoon_test.foo!
  end

  it "should meta-program before_* hooks" do
    @big_spoon_test.should_receive(:hook_8)
    BigSpoonTest.before_foo! :hook_8
    @big_spoon_test.foo!
  end

  it "should handle a set number of arguments in methods" do
    BigSpoonTest.before :i_accept_one, :hook_9
    @big_spoon_test.should_receive(:puts).with("ohai")
    @big_spoon_test.i_accept_one("ohai")
  end

  it "should handle an arbitrary number of arguments in methods" do
    BigSpoonTest.before :i_accept_many, :hook_10
    @big_spoon_test.should_receive(:puts).with(["ohai", "i'll be an array", "someday"])
    @big_spoon_test.i_accept_many("ohai", "i'll be an array", "someday")
  end

  it "should handle an optional argument" do
    BigSpoonTest.after :i_might_accept_one, :hook_11
    @big_spoon_test.should_receive(:puts).with(nil)
    @big_spoon_test.i_might_accept_one
  end

  it "should debug clearly when a method throws an error" do
    BigSpoonTest.after :raise_sommat, :hook_12
    begin
      @big_spoon_test.raise_sommat
    rescue
      $!.backtrace.first.should =~ /:\d+\:in `raise_sommat'/
    end
  end
end
