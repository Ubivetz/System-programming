pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git(
                    url: 'https://github.com/Ubivetz/System-programming.git',
                    branch: 'master',
                    credentialsId: 'github-pat' 
                )
            }
        }
        stage('Build RPM and DEB') {
            parallel {
                stage('Build RPM') {
                    agent {
                        docker {
                            image 'centos:7'
                            args '-v /var/run/docker.sock:/var/run/docker.sock'
                        }
                    }
                    steps {
                        script {
                            sh 'yum install -y rpm-build'
                            sh '''
                                mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
                                cp count_files.sh ~/rpmbuild/SOURCES/
                                cp count_files.spec ~/rpmbuild/SPECS/
                                rpmbuild -ba ~/rpmbuild/SPECS/count_files.spec
                            '''
                        }
                    }
                    post {
                        success {
                            archiveArtifacts artifacts: '~/rpmbuild/RPMS/**/*.rpm', allowEmptyArchive: true
                        }
                    }
                }

                stage('Build DEB') {
                    agent {
                        docker {
                            image 'ubuntu:latest'
                            args '-v /var/run/docker.sock:/var/run/docker.sock'
                        }
                    }
                    steps {
                        script {
                            sh 'apt-get update && apt-get install -y dpkg-dev'
                            sh '''
                                mkdir -p count-files-1.0/DEBIAN
                                mkdir -p count-files-1.0/usr/local/bin
                                cp count_files.sh count-files-1.0/usr/local/bin/
                                chmod 755 count-files-1.0/usr/local/bin/count_files.sh
                                echo "Package: count-files" > count-files-1.0/DEBIAN/control
                                echo "Version: 1.0" >> count-files-1.0/DEBIAN/control
                                echo "Section: base" >> count-files-1.0/DEBIAN/control
                                echo "Priority: optional" >> count-files-1.0/DEBIAN/control
                                echo "Architecture: all" >> count-files-1.0/DEBIAN/control
                                echo "Maintainer: Pavlo Derkach <pawel.a.derckach@gmail.com>" >> count-files-1.0/DEBIAN/control
                                echo "Description: Script to count files in /etc" >> count-files-1.0/DEBIAN/control
                                echo " A simple Bash script that counts the number of regular files in the /etc directory." >> count-files-1.0/DEBIAN/control
                                dpkg-deb --build count-files-1.0
                            '''
                        }
                    }
                    post {
                        success {
                            archiveArtifacts artifacts: './count-files-1.0.deb', allowEmptyArchive: true
                        }
                    }
                }
            }
        }
        stage('Test RPM Package') {
            agent {
                docker {
                    image 'centos:7'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                script {
                    sh '''
                        yum localinstall -y ~/rpmbuild/RPMS/x86_64/*.rpm
                        /usr/local/bin/count_files.sh
                    '''
                }
            }
        }
        stage('Test DEB Package') {
            agent {
                docker {
                    image 'ubuntu:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                script {
                    sh '''
                        dpkg -i ./count-files-1.0.deb
                        /usr/local/bin/count_files.sh
                    '''
                }
            }
        }
    }
}
