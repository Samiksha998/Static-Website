pipeline { 
    agent any

    environment {
        KUBECONFIG = "/home/ec2-user/.kube/config"
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
                    sh '''
                    echo "=== Building and Pushing Docker Image ==="

                    # Build image
                    echo 'admin' | sudo -S docker build -t $IMAGE_NAME .

                    # Push to Docker Hub
                    echo 'admin' | sudo -S docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                    echo "=== Deploying Kubernetes Manifests ==="

                    # Apply each manifest file
                    echo 'admin' | sudo -S kubectl apply -f $K8S_DIR/app-deployment.yaml
                    echo 'admin' | sudo -S kubectl apply -f $K8S_DIR/app-service.yaml

                    echo "=== Updating Deployment Image ==="

                    # Update deployment with latest image
                    echo 'admin' | sudo -S kubectl set image deployment/static-website-deployment \
                        static-website=$IMAGE_NAME --namespace=default || true

                    # Rollout status
                    echo 'admin' | sudo -S kubectl rollout status deployment/static-website-deployment -n default
                    '''
                }
            }
        }

        stage('Port Forwarding') {
            steps {
                script {
                    sh '''
                    echo "=== Handling Port Forward ==="

                    # Stop existing port-forward on 9090
                    sudo kill -9 $(sudo lsof -t -i:9090) 2>/dev/null || true

                    echo "=== Starting New Port Forward ==="
                    nohup sh -c "echo 'admin' | sudo -S kubectl port-forward svc/static-website-service 9090:80 --address=0.0.0.0" \
                        > port-forward.log 2>&1 &

                    echo "Static website: http://<EC2-PUBLIC-IP>:9090"
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
