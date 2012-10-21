class MavenTest < MiniTest::Chef::TestCase

  def test_exist_file
    assert File.exist?('C:/Tools/maven/apache-maven-2.2.1/bin/mvn.bat')
  end
  
  def test_maven_runs
	mvnCommand = Chef::ShellOut.new("C:/Tools/maven/apache-maven-2.2.1/bin/mvn.bat -v")
	mvnCommand.run_command
	assert mvnCommand.stdout.include?('Apache Maven 2.2.1 (r801777; 2009-08-06 15:16:01-0400)')
	# Raise an exception if it didn't exit with 0
	mvnCommand.error!
  end

  def test_succeed
    assert run_status.success?
  end
end