#!/bin/bash

# QUICK CONTAINERIZATION SETUP - Lightweight approach
# Creates minimal office/personal workspace separation

set -e

echo "🚀 Quick containerization setup - minimal containers..."

# Create simple office container
cat > Dockerfile.office-minimal << 'EOF'
FROM alpine:3.18

# Basic tools
RUN apk add --no-cache \
    git \
    bash \
    curl \
    jq

# Office git identity
RUN git config --global user.name "Abhishek Srivastava" && \
    git config --global user.email "abhissrivasta@expediagroup.com"

WORKDIR /workspace
ENV PS1="🏢 OFFICE [\w]$ "
CMD ["/bin/bash"]
EOF

# Create personal container
cat > Dockerfile.personal-minimal << 'EOF'
FROM alpine:3.18

# Basic tools + python
RUN apk add --no-cache \
    git \
    bash \
    curl \
    jq \
    python3 \
    py3-pip

# Personal git identity
RUN git config --global user.name "Abhishek Srivastava" && \
    git config --global user.email "bits.abhi@gmail.com"

WORKDIR /personal
ENV PHI_CONSTANT="1.618033988749895"
ENV PS1="🏠 PERSONAL [\w]$ "
CMD ["/bin/bash"]
EOF

# Build minimal containers
echo "🏗️ Building minimal office container..."
docker build -t office-minimal:latest -f Dockerfile.office-minimal .

echo "🏗️ Building minimal personal container..."
docker build -t personal-minimal:latest -f Dockerfile.personal-minimal .

# Create workspace aliases
cat >> ~/.bashrc << 'EOF'

# Container workspace separation
office() {
    echo "🏢 Entering Office Environment..."
    docker run -it --rm \
        -v ~/GolandProjects:/workspace \
        -v ~/.ssh:/root/.ssh:ro \
        --name office-workspace \
        office-minimal:latest
}

personal() {
    echo "🏠 Entering Personal Environment..."
    docker run -it --rm \
        -v ~/PersonalProjects:/personal \
        -v ~/meaning:/personal/meaning \
        -v ~/.ssh:/root/.ssh:ro \
        --name personal-workspace \
        personal-minimal:latest
}

workspace-status() {
    echo "Active workspaces:"
    docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
}
EOF

echo ""
echo "✅ Quick containerization complete!"
echo ""
echo "Usage:"
echo "  office    - Enter office environment"
echo "  personal  - Enter personal environment"
echo "  workspace-status - Show active containers"
echo ""
echo "Reload shell: source ~/.bashrc"