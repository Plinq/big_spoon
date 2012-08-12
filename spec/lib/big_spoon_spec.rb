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

  private
  def by_all_means_hook
    true
  end

  def dont_hook
    false
  end

  def hook_1
    :hook_1
  end

  def hook_2
    :hook_2
  end

  def hook_3
    :hook_3
  end
end

describe BigSpoon do
  before :each do
    @big_spoon_test = BigSpoonTest.new
  end

  it "should monkeypatch Object" do
    Object.should respond_to(:hooks)
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
end
