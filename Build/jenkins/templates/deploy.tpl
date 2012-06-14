<?xml version='1.0' encoding='UTF-8'?>
<project>
  <actions/>
  <description>$description</description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <com.nirima.AdaptivePluginProperty>
      <script></script>
    </com.nirima.AdaptivePluginProperty>
    <hudson.plugins.throttleconcurrents.ThrottleJobProperty>
      <maxConcurrentPerNode>0</maxConcurrentPerNode>
      <maxConcurrentTotal>0</maxConcurrentTotal>
      <categories>
        <string>virgo</string>
      </categories>
      <throttleEnabled>true</throttleEnabled>
      <throttleOption>category</throttleOption>
    </hudson.plugins.throttleconcurrents.ThrottleJobProperty>
  </properties>
  <scm class="hudson.plugins.git.GitSCM">
    <configVersion>2</configVersion>
    <userRemoteConfigs>
      <hudson.plugins.git.UserRemoteConfig>
        <name></name>
        <refspec></refspec>
        <url>$gitUrl</url>
      </hudson.plugins.git.UserRemoteConfig>
    </userRemoteConfigs>
    <branches>
      <hudson.plugins.git.BranchSpec>
        <name>$gitBranch</name>
      </hudson.plugins.git.BranchSpec>
    </branches>
    <disableSubmodules>false</disableSubmodules>
    <recursiveSubmodules>false</recursiveSubmodules>
    <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
    <authorOrCommitter>false</authorOrCommitter>
    <clean>false</clean>
    <wipeOutWorkspace>false</wipeOutWorkspace>
    <pruneBranches>true</pruneBranches>
    <remotePoll>false</remotePoll>
    <ignoreNotifyCommit>false</ignoreNotifyCommit>
    <buildChooser class="hudson.plugins.git.util.DefaultBuildChooser"/>
    <gitTool>Default</gitTool>
    <submoduleCfg class="list"/>
    <relativeTargetDir></relativeTargetDir>
    <reference></reference>
    <excludedRegions></excludedRegions>
    <excludedUsers></excludedUsers>
    <gitConfigName></gitConfigName>
    <gitConfigEmail></gitConfigEmail>
    <skipTag>false</skipTag>
    <includedRegions>Product/.*</includedRegions>
    <scmName></scmName>
  </scm>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers class="vector"/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.plugins.gradle.Gradle>
      <description></description>
      <switches></switches>
      <tasks>stopServers</tasks>
      <rootBuildScriptDir>./Product</rootBuildScriptDir>
      <buildFile></buildFile>
      <gradleName>gradle-1.0-rc-3</gradleName>
      <useWrapper>false</useWrapper>
    </hudson.plugins.gradle.Gradle>
    <hudson.tasks.Maven>
      <targets>install -Dmaven.test.skip</targets>
      <mavenName>maven-2.2.1</mavenName>
      <jvmOptions>-Xmx512m -XX:MaxPermSize=256m</jvmOptions>
      <pom>./Product/pom.xml</pom>
      <usePrivateRepository>false</usePrivateRepository>
    </hudson.tasks.Maven>
    <hudson.plugins.gradle.Gradle>
      <description></description>
      <switches></switches>
      <tasks>deploy startServers</tasks>
      <rootBuildScriptDir>./Product</rootBuildScriptDir>
      <buildFile></buildFile>
      <gradleName>gradle-1.0-rc-3</gradleName>
      <useWrapper>false</useWrapper>
    </hudson.plugins.gradle.Gradle>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>