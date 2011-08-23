$LOAD_PATH << File.join(File.dirname(__FILE__),'..','services')
require "test/unit/testcase"
require 'test/unit/ui/console/testrunner'
require "system_agents/ssh_config"

class TestSshConfig < Test::Unit::TestCase
  def setup
    @data_dir = File.join(File.dirname(__FILE__),"data")
  end

  def test_reading
    file = SystemAgents::SshConfig.new nil
    ret = file.read "_aug_internal" => Augeas::open(@data_dir,"/tmp/lens", Augeas::NO_MODL_AUTOLOAD)
    assert_equal ["LC_IDENTIFICATION", "LC_ALL"], ret["SendEnv"]
    assert_equal "suse.cz", ret["Host"][0]["Host"]
    assert_equal "*", ret["Host"][1]["Host"]
    assert_equal ["LC_LANG"], ret["Host"][1]["SendEnv"]
  end

end

Test::Unit::UI::Console::TestRunner.run(TestSshConfig)