pipeline {
    agent any

    environment {
        KUBECONFIG = "/home/ec2-user/.kube/config"
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
                    sh '''
                    echo "=== Building and Pushing Docker Image ==="

                    # Build Docker image
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
                    echo "=== Deploying Application to Kubernetes ==="

                    # Apply deployment & service YAMLs
                    echo 'admin' | sudo -S kubectl apply -f kubernetes/

                    # Update deployment image
                    echo 'admin' | sudo -S kubectl set image deployment/static-website-deployment \
                        static-website=$IMAGE_NAME -n default || true

                    # Wait for deployment rollout
                    echo 'admin' | sudo -S kubectl rollout status deployment/static-website-deployment -n default
                    '''
                }
            }
        }

        stage('Port Forwarding') {
            steps {
                script {
                    sh '''
                    echo "=== Starting Kubernetes Port Forwarding ==="

                    # Kill any existing port-forward on 9090
                    sudo kill -9 $(sudo lsof -t -i:9090) 2>/dev/null || true

                    # Start port forwarding in background
                    nohup sh -c "echo 'admin' | sudo -S kubectl port-forward svc/static-website-service 9090:80 --address=0.0.0.0" \
                        > port-forward.log 2>&1 &

                    echo "Website accessible at: http://<your-ec2-public-ip>:9090"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Static Website successfully deployed and accessible at port 9090!"
        }
        failure {
            echo "❌ Deployment or port-forwarding failed. Check Jenkins logs."
        }
        always {
            echo "🏁 Pipeline completed."
        }
    }
}
