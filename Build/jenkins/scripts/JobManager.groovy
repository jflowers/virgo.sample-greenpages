

import groovy.text.SimpleTemplateEngine

class JobManager {

    def jenkinsBaseUrl = 'http://localhost:8080'

    def workspaceDir = System.getProperty('workspaceDir')
    def buildXmlApiUrl = System.getProperty('buildXmlApiUrl')
	def gitBranch = System.getProperty('gitBranch').replace('origin/', '')

    public static void main(args){
        def self = new JobManager();
        self.run();
    }

    def run(){
		
		if (gitBranch == 'HEAD')
		{
			gitBranch = '"C:\Program Files (x86)\Git\cmd\git.cmd" symbolic-ref refs/remotes/origin/HEAD'.execute().text.trim().replace('refs/remotes/origin/', '')
			println "resetting current branch name to $gitBranch, was pointed to HEAD"
		}
        def build = new XmlSlurper().parse(buildXmlApiUrl)

		boolean changesFound = false
        build.changeSet.'**'.grep{ it.name() == 'affectedPath' && it.text().endsWith('.kin') }.each {path ->
			changesFound = true
            String svnPath = path.text()
            String kinBuildFilePath = convertFromSvnPathToFilePath(svnPath)
            buildAndPublishJobs(kinBuildFilePath)
        }
		
		//this executes if there where no changes, thre would be no changes in two instances, a forced build and the introduction of a new branch
		if (!changesFound) {
			def dir = new File('./Build/jenkins')
			dir.traverse(
				type:groovy.io.FileType.FILES,
				nameFilter:~/.*\.kin/,
				maxDepth:0
			) { kinBuildFilePath ->
				buildAndPublishJobs(kinBuildFilePath.absolutePath)
			}
		}
    }
	
	def buildAndPublishJobs(String kinBuildFilePath) {
		buildJobConfig(kinBuildFilePath).each { Job job ->
			if (!doesJobExist(job.name)) {
				createJob(job)
			} else {
				updateJob(job)
			}
		}
	}

    @GrabResolver(name = "ch33nexus", root = "http://10.153.10.173:8082/nexus/content/groups/public")
    @Grab('jenkins:jenkins-cli:1.460')
    def runCliCommand(List<String> args, InputStream input = System.in,
        OutputStream output = System.out, OutputStream err = System.err)
    {
        def hudson.cli.CLI cli = new hudson.cli.CLI(jenkinsBaseUrl.toURI().toURL())
        cli.execute(args, input, output, err)
        cli.close()
    }

    def createJob(Job job){
		println "creating job ${job.name} in jenkins ${jenkinsBaseUrl}"
        FileInputStream configFileInputStream = new FileInputStream(job.configFile)
        runCliCommand(['create-job', job.name], configFileInputStream)
    }

    def updateJob(Job job){
		println "updating job ${job.name} in jenkins ${jenkinsBaseUrl}"
        FileInputStream configFileInputStream = new FileInputStream(job.configFile)
        runCliCommand(['update-job', job.name], configFileInputStream)
    }

    def boolean doesJobExist(String jobName)  {
        def slurper = new XmlSlurper()
        def jenkinsMain = slurper.parse("$jenkinsBaseUrl/api/xml")
		
		boolean found = false
		jenkinsMain.job.each{
			if (it.name.text() == jobName) {
				found = true
			}
		}

        return found
    }

    @GrabResolver	(name = "ch33nexus", root = "http://10.153.10.173:8082/nexus/content/groups/public")
    @Grab('hr.helix:kin:1.0')
    def List<Job> buildJobConfig(String kinBuildFilePath) {
        println "processing $kinBuildFilePath"
        hr.helix.kin.IO io = new hr.helix.kin.IO()
        hr.helix.kin.script.Runner runner = new hr.helix.kin.script.Runner()
        SimpleTemplateEngine engine = new groovy.text.SimpleTemplateEngine()
        String dsl = new File(kinBuildFilePath).getText()

        def build = runner.run(dsl)
		def jobs = new ArrayList<Job>()
        build.producers().each { job ->
			if (job.gitBranch != gitBranch)
			{
				println "Error: Job ${job.name} git branch is not set correctly, was expecting $gitBranch, but ${job.gitBranch} is set.  In file $kinBuildFilePath."
				System.exit(1)
			}
            def name = job.name
            def templates = build.templates(name)
            def template = findValidTemplate(kinBuildFilePath, templates)
            if (!template) {
                System.err.println "No template $templates for job '$name'!"
                System.exit 4
            }

            def traits = build.traits(name)
            def config = engine.createTemplate(template).make(traits)

            def configFile = new File("$workspaceDir/build/$name/config.xml")
            io.writeConfig config, configFile
            println "creating ${configFile.absolutePath}"
			jobs.add(new Job(name: name, configFile: configFile))
        }

        return jobs
    }

    File findValidTemplate(String kinBuildFilePath, List<String> templateNames) {
		
        templateNames.findResult { name ->
			def templatePath = new File(kinBuildFilePath).parent + '/' + name
			println "looking for template here: $templatePath"
            def template = new File(templatePath)
            template.isFile() ? template : null
        }
    }

    def String convertFromSvnPathToFilePath(String svnPath){
        def removeFromSvnPath = '/Users/flowersj/job-templates'
        def baseFilePath = workspaceDir

        def filePath = svnPath.replace(removeFromSvnPath, baseFilePath)
        return filePath
    }

}