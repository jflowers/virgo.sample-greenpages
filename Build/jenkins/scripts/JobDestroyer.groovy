@GrabResolver(
     name='jgit-repository', 
     root='http://download.eclipse.org/jgit/maven'
)
@Grab(
     group='org.eclipse.jgit',
     module='org.eclipse.jgit',
     version='1.1.0.201109151100-r'
)

import org.eclipse.jgit.*
import org.eclipse.jgit.lib.*
import org.eclipse.jgit.util.*

class JobDestroyer {

    def jenkinsBaseUrl = 'http://localhost:8080'
	def remoteBranches = []

    public static void main(args){
        def self = new JobDestroyer();
        self.run();
    }

    def run(){
		Repository repository = RepositoryCache.open(RepositoryCache.FileKey.lenient(new File(directory),FS.DETECTED), true)
		
		Map<String, Ref> remotesRefList = repository.getRefDatabase().getRefs(Constants.R_REMOTES)
		for (String remoteKey : remotesRefList.keySet()) {
			def branchName = remoteKey.replace('origin/', '')
			println "found remote branch $branchName"
			remoteBranches.push(branchName)
		}

        def jenkinsMain = new XmlSlurper().parse("$jenkinsBaseUrl/api/xml")
		
		jenkinsMain.job.grep{ job -> job.name != 'Creator' && job.name != 'Destroyer' }.each{ job ->
			println "checking if we should destroy job ${job.name}"
			def jobConfig = new XmlSlurper().parseText(getJob(job.name))
			def gitBranch = jobConfig.'*'.scm.branches.'hudson.plugins.git.BranchSpec'.name
			println "checking if remote branch $gitBranch exists"
			if (!gitBranch in remoteBranches) {
				deleteJob(job.name)
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

    def deleteJob(String jobName){
		println "deleting job $jobName in jenkins $jenkinsBaseUrl"
        runCliCommand(['delete-job', jobName])
    }

    def String getJob(String jobName){
		println "geting job $jobName in jenkins $jenkinsBaseUrl"
		ByteArrayOutputStream output = new ByteArrayOutputStream()
        runCliCommand(['get-job', jobName], System.in, output, System.err)
		return output.toString()
    }


}