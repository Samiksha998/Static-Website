pipeline {
    agent any

    environment {
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
        IMAGE_NAME = "samikshav/static-website:latest"
        AWS_REGION = "us-east-1"
        CLUSTER_NAME = "mycluster"
    }

    stages {

        /* ----------------------------
           1. CHECKOUT CODE
        ----------------------------- */
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Samiksha998/Static-Website.git', branch: 'main'
            }
        }

        /* ----------------------------
           2. BUILD & PUSH DOCKER IMAGE
        ----------------------------- */
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

                        echo "=== Pushing Docker Image ==="
                        docker push $IMAGE_NAME

                        docker logout
                        '''
                    }
                }
            }
        }

        /* ----------------------------
           3. SETUP KUBECONFIG & AWS CREDS
        ----------------------------- */
        stage('Setup kubeconfig for Jenkins') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds']]) {

                        sh '''
                        echo "=== Ensuring Jenkins .kube Directory ==="
                        mkdir -p /var/lib/jenkins/.kube

                        echo "=== Updating kubeconfig from EKS ==="
                        aws eks update-kubeconfig \
                            --region $AWS_REGION \
                            --name $CLUSTER_NAME \
                            --kubeconfig $KUBECONFIG

                        echo "=== Test EKS Connectivity ==="
                        kubectl get nodes --kubeconfig=$KUBECONFIG
                        '''
                    }
                }
            }
        }

        /* ----------------------------
           4. DEPLOY TO KUBERNETES
        ----------------------------- */
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds']]) {

                        sh '''
                        echo "=== Applying Deployment & Service Manifests ==="
                        kubectl apply -f $WORKSPACE/kubernetes/app-deploy.yaml --kubeconfig=$KUBECONFIG
                        kubectl apply -f $WORKSPACE/kubernetes/app-service.yaml --kubeconfig=$KUBECONFIG

                        echo "=== Updating Deployment Image ==="
                        kubectl set image deployment/static-website-app \
                            web=$IMAGE_NAME --namespace=default --kubeconfig=$KUBECONFIG

                        echo "=== Waiting for Rollout ==="
                        kubectl rollout status deployment/static-website-app \
                            -n default --kubeconfig=$KUBECONFIG
                        '''
                    }
                }
            }
        }

        /* ----------------------------
           5. PORT FORWARDING
        ----------------------------- */
        stage('Port Forwarding') {
            steps {
                script {
                    sh '''
                    echo "=== Killing Old Port Forward ==="
                    kill -9 $(lsof -t -i:9090) 2>/dev/null || true

                    echo "=== Starting Port Forward on 9090 ==="
                    nohup kubectl port-forward svc/static-website-service 9090:80 \
                        --address=0.0.0.0 --kubeconfig=$KUBECONFIG \
                        > $WORKSPACE/port-forward.log 2>&1 &

                    echo "App Live: http://<EC2-PUBLIC-IP>:9090"
                    '''
                }
            }
        }
    }

    /* ----------------------------
       6. POST BUILD ACTIONS
    ----------------------------- */
    post {
        success {
            echo "✅ Deployment successful! App: http://<EC2-PUBLIC-IP>:9090"
        }
        failure {
            echo "❌ Deployment failed. Check Jenkins pipeline logs."
        }
        always {
            echo "🏁 Pipeline completed."
        }
    }
}
