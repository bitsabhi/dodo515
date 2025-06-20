#!/bin/bash

# CONTAINERIZATION SETUP - Office/Personal Boundary Separation
# Solves: Forever loop, boundary conditions, manual context switching

set -e

echo "🔧 Setting up container-based workspace separation..."

# Create Dockerfiles
cat > Dockerfile.office << 'EOF'
FROM ubuntu:22.04

# Office environment setup
RUN apt-get update && apt-get install -y \
    golang \
    git \
    vim \
    curl \
    jq \
    wget

# Permanent office git identity
RUN git config --global user.name "Abhishek Srivastava" && \
    git config --global user.email "abhissrivasta@expediagroup.com"

# Office workspace
WORKDIR /workspace
VOLUME ["/workspace"]

# Office environment
ENV OFFICE_MODE="true"
ENV PS1="🏢 OFFICE [\w]$ "

CMD ["/bin/bash"]
EOF

cat > Dockerfile.personal << 'EOF'
FROM node:18-alpine

# Personal development environment
RUN apk add --no-cache \
    python3 \
    py3-pip \
    git \
    bash \
    curl \
    jq

# Permanent personal git identity  
RUN git config --global user.name "Abhishek Srivastava" && \
    git config --global user.email "bits.abhi@gmail.com"

# Personal workspace
WORKDIR /personal
VOLUME ["/personal"]

# Personal environment with phi constants
ENV PERSONAL_MODE="true"
ENV PHI_CONSTANT="1.618033988749895"
ENV PS1="🏠 PERSONAL [\w]$ "

CMD ["/bin/bash"]
EOF

# Build containers
echo "🏗️ Building office container..."
docker build -t office-env:latest -f Dockerfile.office .

echo "🏗️ Building personal container..."
docker build -t personal-env:latest -f Dockerfile.personal .

# Create workspace management script
cat > ~/bin/workspace-manager.sh << 'EOF'
#!/bin/bash

office() {
    echo "🏢 Entering Office Environment..."
    docker run -it --rm \
        -v ~/GolandProjects:/workspace \
        -v ~/.ssh:/root/.ssh:ro \
        --name office-workspace \
        office-env:latest
}

personal() {
    echo "🏠 Entering Personal Environment..."
    docker run -it --rm \
        -v ~/PersonalProjects:/personal \
        -v ~/meaning:/personal/meaning \
        -v ~/.ssh:/root/.ssh:ro \
        --name personal-workspace \
        personal-env:latest
}

status() {
    echo "Active workspaces:"
    docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
}

cleanup() {
    echo "🧹 Cleaning up workspace containers..."
    docker container prune -f
    docker image prune -f
}

EOF

chmod +x ~/bin/workspace-manager.sh

# Add to shell profile
if ! grep -q "workspace-manager" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Container-based workspace separation" >> ~/.bashrc
    echo "source ~/bin/workspace-manager.sh" >> ~/.bashrc
    echo "alias office='office'" >> ~/.bashrc
    echo "alias personal='personal'" >> ~/.bashrc
    echo "alias workspace-status='status'" >> ~/.bashrc
fi

echo ""
echo "✅ Containerization setup complete!"
echo ""
echo "Usage:"
echo "  office    - Enter office environment (GolandProjects/)"
echo "  personal  - Enter personal environment (PersonalProjects/)"
echo "  workspace-status - Show active containers"
echo ""
echo "🎯 Solution Benefits:"
echo "  ✅ No more manual git identity switching"
echo "  ✅ Complete filesystem isolation"
echo "  ✅ Contextually pure environments"
echo "  ✅ Eliminates boundary condition problems"
echo "  ✅ Gets you out of the forever loop"
echo ""
echo "Restart terminal or run: source ~/.bashrc"