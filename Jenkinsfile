pipeline { 
    agent any

    environment {
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
        IMAGE_NAME = "samikshav/static-website:latest"
        K8S_DIR = "kubernetes"
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
                        docker build -t $IMAGE_NAME .

                        echo "=== Pushing Image ==="
                        docker push $IMAGE_NAME

                        echo "=== Docker Logout ==="
                        docker logout
                        '''
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                    echo "=== Applying Kubernetes Manifests ==="

                    kubectl apply -f $K8S_DIR/app-deployment.yaml
                    kubectl apply -f $K8S_DIR/app-service.yaml

                    kubectl set image deployment/static-website-deployment \
                        static-website=$IMAGE_NAME --namespace=default || true

                    kubectl rollout status deployment/static-website-deployment -n default
                    '''
                }
            }
        }

        stage('Port Forwarding') {
            steps {
                script {
                    sh '''
                    echo "=== Killing Old Port-Forward (if any) ==="
                    kill -9 $(lsof -t -i:9090) 2>/dev/null || true
                    
                    echo "=== Starting New Port Forward on 9090 ==="
                    nohup kubectl port-forward svc/static-website-service 9090:80 --address=0.0.0.0 \
                        > port-forward.log 2>&1 &
                    
                    echo "Application live at: http://<EC2-PUBLIC-IP>:9090"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful! Access at port 9090."
        }
        failure {
            echo "❌ Deployment failed. Check console output."
        }
        always {
            echo "🏁 Pipeline finished."
        }
    }
}
