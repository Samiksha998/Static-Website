pipeline { 
    agent any

    environment {
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
        IMAGE_NAME = "samikshav/static-website:latest"
    }

    stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/Samiksha998/Static-Website.git', branch: 'main'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS')]) {

                        sh '''
                        echo "=== Logging in to Docker Hub ==="
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                        echo "=== Building Docker Image ==="
                        docker build -t $IMAGE_NAME $WORKSPACE

                        echo "=== Pushing Image to Docker Hub ==="
                        docker push $IMAGE_NAME

                        echo "=== Docker Logout ==="
                        docker logout
                        '''
                    }
                }
            }
        }

        stage('Setup kubeconfig for Jenkins') {
            steps {
                script {
                    sh '''
                    echo "=== Copying kubeconfig for Jenkins user ==="
                    mkdir -p /var/lib/jenkins/.kube

                    # Copy only if not already present
                    cp -f /home/ec2-user/.kube/config /var/lib/jenkins/.kube/config || true

                    chown -R jenkins:jenkins /var/lib/jenkins/.kube

                    echo "=== Verifying EKS connectivity ==="
                    kubectl get nodes --kubeconfig=$KUBECONFIG
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                    echo "=== Applying Kubernetes Manifests ==="
                    kubectl apply -f $WORKSPACE/kubernetes/app-deploy.yaml --kubeconfig=$KUBECONFIG
                    kubectl apply -f $WORKSPACE/kubernetes/app-service.yaml --kubeconfig=$KUBECONFIG

                    echo "=== Updating Deployment Image ==="
                    kubectl set image deployment/static-website-app \
                        web=$IMAGE_NAME --namespace=default --kubeconfig=$KUBECONFIG

                    echo "=== Waiting for Deployment Rollout ==="
                    kubectl rollout status deployment/static-website-app -n default --kubeconfig=$KUBECONFIG
                    '''
                }
            }
        }

        stage('Port Forwarding') {
            steps {
                script {
                    sh '''
                    echo "=== Killing Existing Port Forward (if any) ==="
                    kill -9 $(lsof -t -i:9090) 2>/dev/null || true

                    echo "=== Starting New Port Forward on Port 9090 ==="
                    nohup kubectl port-forward svc/static-website-service 9090:80 \
                        --address=0.0.0.0 --kubeconfig=$KUBECONFIG \
                        > $WORKSPACE/port-forward.log 2>&1 &

                    echo "Application available at: http://<EC2-PUBLIC-IP>:9090"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful! Access app at port 9090."
        }
        failure {
            echo "❌ Deployment failed. Check Jenkins logs."
        }
        always {
            echo "🏁 Pipeline completed."
        }
    }
}
