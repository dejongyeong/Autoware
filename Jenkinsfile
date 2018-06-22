#!groovy​

pipeline {
  agent {
    label 'pull-push'
  }

  parameters {
    booleanParam(defaultValue: false, name: 'NO_CACHE', description: 'build docker images with no cache')
  }

  stages {
    stage("setup and info") {
      steps {
        script {
          env.GIT_COMMIT_SHORT = sh(returnStdout: true, script: 'git rev-parse HEAD | cut -c 1-7').trim()
          env.GIT_COMMIT_AUTHOR = sh(returnStdout: true, script: 'git log --format="%aN" HEAD -n 1').trim()
          env.GIT_COMMIT_AUTHOR_EMAIL = sh(returnStdout: true, script: 'git log --format="%aE" HEAD -n 1').trim()
          env.GIT_COMMIT_AUTHOR_EMAIL_COMBINED = sh(returnStdout: true, script: 'git log --format="%aN<%aE>" HEAD -n 1').trim()
          env.GIT_COMMIT_SUBJECT = sh(returnStdout: true, script: 'git log --format="%s" HEAD -n 1').trim()

        }
        echo "\n \
        building on node ${env.NODE_NAME} \n \
        NO_CACHE: ${params.NO_CACHE}\n \
        BRANCH_NAME: ${env.BRANCH_NAME} \n \
        GIT_COMMIT: ${env.GIT_COMMIT} \n \
        GIT_COMMIT_SHORT: ${env.GIT_COMMIT_SHORT} \n \
        GIT_COMMIT_AUTHOR_EMAIL_COMBINED: ${env.GIT_COMMIT_AUTHOR_EMAIL_COMBINED} \n \
        GIT_COMMIT_SUBJECT: ${env.GIT_COMMIT_SUBJECT}"
      } //steps
    } //stage "setup and info"

    stage("docker image") {

      steps {
        script {
          if ( params.NO_CACHE == true )
            env.DOCKER_BUILD_OPTS = "--no-cache"
          else
            env.DOCKER_BUILD_OPTS = ""
          docker.withRegistry('https://gcr.io', 'gcr:auro-robotics') 
          {
            sh '''
              cd docker/generic && docker build '''+env.DOCKER_BUILD_OPTS+''' -t gcr.io/auro-robotics/autoware .
              docker push  gcr.io/auro-robotics/autoware
              docker rmi  gcr.io/auro-robotics/autoware
            '''
          }
        }
      }
    }
  }
}