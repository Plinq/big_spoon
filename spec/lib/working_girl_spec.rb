require 'working_girl'

class WorkingGirlTest
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

describe WorkingGirl do
  before :each do
    @working_girl_test = WorkingGirlTest.new
  end

  it "should monkeypatch Object" do
    Object.should respond_to(:hooks)
  end

  it "should allow me to add a hook before an object's methods BEFORE THEY EXIST" do
    @working_girl_test.should_receive(:hook_1)
    @working_girl_test.foo!
  end

  it "should allow me to add a hook after an object's methods AFTER THEY EXIST" do
    WorkingGirlTest.hooks do
      after :bar!, :hook_2
    end
    @working_girl_test.should_receive(:hook_2)
    @working_girl_test.bar!
  end

  it "should allow me to add a hook lambda" do
    WorkingGirlTest.hooks do
      after :bar! do
        puts self.inspect
      end
    end
    @working_girl_test.should_receive(:puts)
    @working_girl_test.should_receive(:inspect)
    @working_girl_test.bar!
  end

  it "should still return the appropriate method's value" do
    @working_girl_test.should_receive(:hook_1)
    @working_girl_test.foo!.should == :foo
  end

  it "should allow me to metaprogram before_* hooks" do
    @working_girl_test.should_receive(:hook_2)
    WorkingGirlTest.hooks do
      before_foo! :hook_2
    end
    @working_girl_test.foo!
  end

  it "should allow me to metaprogram after_* hooks" do
    @working_girl_test.should_receive(:hook_3)
    WorkingGirlTest.hooks do
      after_foo! :hook_3
    end
    @working_girl_test.foo!
  end
end
