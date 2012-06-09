

import groovy.text.SimpleTemplateEngine

class JobManager {

    def jenkinsBaseUrl = 'http://localhost:8080'

    def workspaceDir = System.getProperty('workspaceDir')
    def changeLogPath = System.getProperty('changeLogPath')

    public static void main(args){
        def self = new JobManager();
        self.run();
    }

    def run(){
        def changes = new XmlSlurper().parseText(new File(changeLogPath).getText())

        changes.'**'.grep{ it.name() == 'path' && it.text().endsWith('.kin') }.each {path ->
            String svnPath = path.text()
            String kinBuildFilePath = convertFromSvnPathToFilePath(svnPath)
            buildJobConfig(kinBuildFilePath).each { Job job ->
				if (!doesJobExist(job.name)) {
					createJob(job)
				} else {
					updateJob(job)
				}
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
            def name = job.name
            def templates = build.templates(name)
            def template = findValidTemplate(templates)
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

    File findValidTemplate(List<String> templateNames) {
        templateNames.findResult { name ->
            def template = new File(workspaceDir, name)
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