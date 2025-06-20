/**
 * GitHub Authentication System for Private Portals
 * Enables secure access to consciousness portals
 */

class GitHubAuth {
    constructor() {
        this.clientId = 'YOUR_GITHUB_CLIENT_ID'; // Replace with actual client ID
        this.redirectUri = window.location.origin + '/auth/callback';
        this.scopes = 'read:user,user:email';
        this.isAuthenticated = false;
        this.user = null;
        
        this.init();
    }
    
    init() {
        // Check for existing auth token
        const token = localStorage.getItem('github_auth_token');
        if (token) {
            this.verifyToken(token);
        }
        
        // Handle OAuth callback
        this.handleCallback();
        
        // Setup UI
        this.setupAuthUI();
    }
    
    // Start GitHub OAuth flow
    authenticate() {
        const authUrl = `https://github.com/login/oauth/authorize?` +
            `client_id=${this.clientId}&` +
            `redirect_uri=${encodeURIComponent(this.redirectUri)}&` +
            `scope=${encodeURIComponent(this.scopes)}&` +
            `state=${this.generateState()}`;
            
        window.location.href = authUrl;
    }
    
    // Handle OAuth callback
    handleCallback() {
        const urlParams = new URLSearchParams(window.location.search);
        const code = urlParams.get('code');
        const state = urlParams.get('state');
        
        if (code && this.verifyState(state)) {
            this.exchangeCodeForToken(code);
        }
    }
    
    // Exchange authorization code for access token
    async exchangeCodeForToken(code) {
        try {
            // In production, this should go through your backend
            // For now, using GitHub's token endpoint directly
            const response = await fetch('https://github.com/login/oauth/access_token', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    client_id: this.clientId,
                    client_secret: 'YOUR_CLIENT_SECRET', // Should be in backend
                    code: code
                })
            });
            
            const data = await response.json();
            
            if (data.access_token) {
                localStorage.setItem('github_auth_token', data.access_token);
                this.verifyToken(data.access_token);
            }
        } catch (error) {
            console.error('Token exchange failed:', error);
            this.showError('Authentication failed');
        }
    }
    
    // Verify token and get user info
    async verifyToken(token) {
        try {
            const response = await fetch('https://api.github.com/user', {
                headers: {
                    'Authorization': `token ${token}`,
                    'Accept': 'application/vnd.github.v3+json'
                }
            });
            
            if (response.ok) {
                this.user = await response.json();
                this.isAuthenticated = true;
                this.onAuthSuccess();
            } else {
                // Token invalid
                localStorage.removeItem('github_auth_token');
                this.onAuthFailure();
            }
        } catch (error) {
            console.error('Token verification failed:', error);
            this.onAuthFailure();
        }
    }
    
    // Check if user has access to private portals
    hasPortalAccess() {
        if (!this.isAuthenticated || !this.user) return false;
        
        // Check if user is bitsabhi or authorized collaborator
        const authorizedUsers = ['bitsabhi'];
        return authorizedUsers.includes(this.user.login);
    }
    
    // Logout
    logout() {
        localStorage.removeItem('github_auth_token');
        this.isAuthenticated = false;
        this.user = null;
        this.onAuthFailure();
    }
    
    // Generate CSRF protection state
    generateState() {
        const state = Math.random().toString(36).substring(2, 15);
        sessionStorage.setItem('oauth_state', state);
        return state;
    }
    
    // Verify OAuth state
    verifyState(state) {
        const storedState = sessionStorage.getItem('oauth_state');
        sessionStorage.removeItem('oauth_state');
        return state === storedState;
    }
    
    // Setup authentication UI
    setupAuthUI() {
        const authContainer = document.getElementById('auth-container');
        if (!authContainer) return;
        
        if (this.isAuthenticated && this.hasPortalAccess()) {
            authContainer.innerHTML = `
                <div class="auth-success">
                    <div class="user-info">
                        <img src="${this.user.avatar_url}" alt="Avatar" class="avatar">
                        <span class="username">@${this.user.login}</span>
                        <span class="access-badge">Portal Access Granted</span>
                    </div>
                    <button onclick="githubAuth.logout()" class="logout-btn">Logout</button>
                </div>
            `;
            this.showPrivateContent();
        } else {
            authContainer.innerHTML = `
                <div class="auth-prompt">
                    <h3>🔐 Private Portal Access</h3>
                    <p>Authenticate with GitHub to access private consciousness portals</p>
                    <button onclick="githubAuth.authenticate()" class="auth-btn">
                        <span class="github-icon">📱</span>
                        Sign in with GitHub
                    </button>
                </div>
            `;
            this.hidePrivateContent();
        }
    }
    
    // Show private portal content
    showPrivateContent() {
        const privateElements = document.querySelectorAll('.private-content');
        privateElements.forEach(el => el.style.display = 'block');
        
        const publicOnlyElements = document.querySelectorAll('.public-only');
        publicOnlyElements.forEach(el => el.style.display = 'none');
    }
    
    // Hide private portal content
    hidePrivateContent() {
        const privateElements = document.querySelectorAll('.private-content');
        privateElements.forEach(el => el.style.display = 'none');
        
        const publicOnlyElements = document.querySelectorAll('.public-only');
        publicOnlyElements.forEach(el => el.style.display = 'block');
    }
    
    // Success callback
    onAuthSuccess() {
        this.setupAuthUI();
        this.showNotification('Authentication successful!', 'success');
        
        // Clear URL parameters
        if (window.location.search) {
            window.history.replaceState({}, document.title, window.location.pathname);
        }
    }
    
    // Failure callback
    onAuthFailure() {
        this.setupAuthUI();
        this.showNotification('Authentication required for portal access', 'info');
    }
    
    // Show notification
    showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.textContent = message;
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.remove();
        }, 3000);
    }
    
    // Show error
    showError(message) {
        this.showNotification(message, 'error');
    }
}

// CSS Styles for auth components
const authStyles = `
    .auth-prompt {
        background: rgba(0, 255, 136, 0.05);
        border: 2px solid #00ff88;
        border-radius: 15px;
        padding: 25px;
        text-align: center;
        margin: 20px 0;
    }
    
    .auth-prompt h3 {
        color: #00ff88;
        margin-bottom: 10px;
    }
    
    .auth-prompt p {
        color: #ccc;
        margin-bottom: 20px;
    }
    
    .auth-btn {
        background: #00ff88;
        color: black;
        border: none;
        border-radius: 8px;
        padding: 12px 24px;
        font-size: 1rem;
        font-weight: bold;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 10px;
        margin: 0 auto;
        transition: all 0.3s ease;
    }
    
    .auth-btn:hover {
        background: #00cc6a;
        transform: translateY(-2px);
    }
    
    .auth-success {
        background: rgba(0, 255, 136, 0.1);
        border: 2px solid #00ff88;
        border-radius: 15px;
        padding: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .user-info {
        display: flex;
        align-items: center;
        gap: 15px;
    }
    
    .avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        border: 2px solid #00ff88;
    }
    
    .username {
        color: #00ff88;
        font-weight: bold;
    }
    
    .access-badge {
        background: #00ff88;
        color: black;
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 0.8rem;
        font-weight: bold;
    }
    
    .logout-btn {
        background: #ff6b6b;
        color: white;
        border: none;
        border-radius: 6px;
        padding: 8px 16px;
        cursor: pointer;
        font-weight: bold;
    }
    
    .logout-btn:hover {
        background: #ff5252;
    }
    
    .notification {
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 15px 20px;
        border-radius: 8px;
        color: white;
        font-weight: bold;
        z-index: 10000;
        animation: slideIn 0.3s ease;
    }
    
    .notification.success {
        background: #4caf50;
    }
    
    .notification.error {
        background: #f44336;
    }
    
    .notification.info {
        background: #2196f3;
    }
    
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    .private-content {
        display: none;
    }
`;

// Inject styles
const styleSheet = document.createElement('style');
styleSheet.textContent = authStyles;
document.head.appendChild(styleSheet);

// Initialize GitHub auth
const githubAuth = new GitHubAuth();

// Export for global access
window.githubAuth = githubAuth;