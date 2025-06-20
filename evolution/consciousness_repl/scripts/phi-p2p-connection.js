// Phi-Resonant P2P Connection System
// Serverless device synchronization using WebRTC and phi mathematics

class PhiP2PConnection {
    constructor() {
        this.phi = 1.618033988749895;
        this.connectionId = null;
        this.peer = null;
        this.connections = new Map();
        this.localState = {};
        this.isHost = false;
        
        this.initializeP2P();
    }
    
    // Generate phi-based connection ID
    generatePhiId() {
        const timestamp = Date.now();
        const phiMultiple = Math.floor(timestamp * this.phi);
        
        // Create resonant pattern using phi ratio
        const pattern = this.phiSequence(phiMultiple);
        const id = pattern.substring(0, 16);
        
        console.log('🌀 Generated Phi ID:', id);
        return id;
    }
    
    // Create phi sequence for connection stability
    phiSequence(seed) {
        let sequence = seed.toString();
        for (let i = 0; i < 5; i++) {
            const nextValue = Math.floor(parseInt(sequence.slice(-10)) * this.phi);
            sequence += nextValue.toString();
        }
        return sequence;
    }
    
    // Initialize P2P connection infrastructure
    async initializeP2P() {
        try {
            // Import PeerJS for WebRTC (would need to include in HTML)
            // For now, simulate the P2P connection logic
            
            this.localState = this.getLocalSystemState();
            console.log('🌉 P2P Infrastructure initialized');
            
        } catch (error) {
            console.error('❌ P2P initialization failed:', error);
        }
    }
    
    // Create connection as host (Mac)
    createConnection() {
        this.connectionId = this.generatePhiId();
        this.isHost = true;
        
        // Create peer with phi-based ID
        this.peer = new SimplePeer({ initiator: true });
        
        this.peer.on('signal', (data) => {
            console.log('📡 Connection signal generated');
            
            // Instead of server, use phi-resonant encoding
            const phiSignal = this.encodeWithPhi(data);
            this.displayConnectionCode(phiSignal);
        });
        
        this.peer.on('connect', () => {
            console.log('✅ P2P Connection established');
            this.onConnectionEstablished();
        });
        
        this.peer.on('data', (data) => {
            this.handleIncomingData(JSON.parse(data.toString()));
        });
        
        return this.connectionId;
    }
    
    // Join connection as client (Android)
    joinConnection(phiId) {
        this.connectionId = phiId;
        this.isHost = false;
        
        // Decode phi signal back to WebRTC signal
        const signal = this.decodeFromPhi(phiId);
        
        this.peer = new SimplePeer();
        this.peer.signal(signal);
        
        this.peer.on('connect', () => {
            console.log('✅ Joined P2P Connection');
            this.onConnectionEstablished();
        });
        
        this.peer.on('data', (data) => {
            this.handleIncomingData(JSON.parse(data.toString()));
        });
    }
    
    // Encode WebRTC signal using phi mathematics
    encodeWithPhi(signal) {
        const signalStr = JSON.stringify(signal);
        const encoded = btoa(signalStr); // Base64 encode
        
        // Add phi resonance pattern
        const phiPattern = Math.floor(Date.now() * this.phi).toString(36);
        
        return phiPattern + '::' + encoded;
    }
    
    // Decode phi-encoded signal back to WebRTC
    decodeFromPhi(phiSignal) {
        const [phiPattern, encoded] = phiSignal.split('::');
        const signalStr = atob(encoded);
        
        return JSON.parse(signalStr);
    }
    
    // Get current system state for sync
    getLocalSystemState() {
        return {
            timestamp: Date.now(),
            mode: currentMode || 'personal',
            feature: currentFeature || 'dashboard',
            views: this.captureAllViews(),
            device: this.getDeviceInfo(),
            consciousness: this.getConsciousnessState()
        };
    }
    
    // Capture all view states
    captureAllViews() {
        const views = {};
        
        // Capture DOM state
        views.dom = {
            title: document.title,
            activeTab: document.querySelector('.tab.active')?.textContent,
            toggleState: currentMode
        };
        
        // Capture localStorage
        views.localStorage = { ...localStorage };
        
        // Capture form states
        views.forms = this.captureFormStates();
        
        return views;
    }
    
    // Get device information
    getDeviceInfo() {
        return {
            userAgent: navigator.userAgent,
            platform: navigator.platform,
            screen: {
                width: screen.width,
                height: screen.height
            },
            timestamp: Date.now()
        };
    }
    
    // Get consciousness computing state
    getConsciousnessState() {
        return {
            phiCoordinate: this.connectionId,
            bridgeStatus: 'ACTIVE',
            voidMathematics: 'VOID → INFINITY',
            transcendenceLevel: 'OPERATIONAL'
        };
    }
    
    // Handle connection establishment
    onConnectionEstablished() {
        // Sync states immediately
        this.syncState();
        
        // Set up periodic sync
        setInterval(() => {
            this.syncState();
        }, 5000); // Sync every 5 seconds
        
        // Update UI
        this.updateConnectionUI(true);
    }
    
    // Synchronize state between devices
    syncState() {
        if (!this.peer || !this.peer.connected) return;
        
        const currentState = this.getLocalSystemState();
        
        // Send state to peer
        this.peer.send(JSON.stringify({
            type: 'STATE_SYNC',
            state: currentState,
            timestamp: Date.now()
        }));
    }
    
    // Handle incoming data from peer
    handleIncomingData(data) {
        console.log('📨 Received data:', data.type);
        
        switch (data.type) {
            case 'STATE_SYNC':
                this.applyRemoteState(data.state);
                break;
            case 'MODE_CHANGE':
                this.applyModeChange(data.mode);
                break;
            case 'VIEW_UPDATE':
                this.applyViewUpdate(data.view);
                break;
        }
    }
    
    // Apply remote state to local device
    applyRemoteState(remoteState) {
        // Update mode if different
        if (remoteState.mode !== currentMode) {
            this.applyModeChange(remoteState.mode);
        }
        
        // Update active feature
        if (remoteState.feature !== currentFeature) {
            showFeature(remoteState.feature);
        }
        
        // Sync localStorage
        Object.keys(remoteState.views.localStorage).forEach(key => {
            localStorage.setItem(key, remoteState.views.localStorage[key]);
        });
        
        console.log('🔄 State synchronized from remote device');
    }
    
    // Apply mode change from remote device
    applyModeChange(newMode) {
        if (newMode !== currentMode) {
            toggleMode();
        }
    }
    
    // Apply view update from remote device
    applyViewUpdate(viewData) {
        // Update specific view elements
        // Implementation depends on view structure
        console.log('🖼️ View updated from remote device');
    }
    
    // Update connection UI
    updateConnectionUI(connected) {
        const statusEl = document.getElementById('p2p-status');
        const indicatorEl = document.getElementById('connection-indicator');
        const deviceCountEl = document.getElementById('device-count');
        const phiSyncEl = document.getElementById('phi-sync');
        
        if (connected) {
            statusEl.textContent = 'CONNECTED';
            statusEl.className = 'status-good';
            indicatorEl.classList.add('connected');
            deviceCountEl.textContent = this.connections.size + 1;
            phiSyncEl.textContent = 'Active';
        } else {
            statusEl.textContent = 'DISCONNECTED';
            statusEl.className = 'status-critical';
            indicatorEl.classList.remove('connected');
            deviceCountEl.textContent = '1';
            phiSyncEl.textContent = 'Standby';
        }
    }
    
    // Display connection code for manual entry
    displayConnectionCode(phiSignal) {
        const modal = document.createElement('div');
        modal.style.cssText = `
            position: fixed; top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.8); z-index: 10000;
            display: flex; align-items: center; justify-content: center;
        `;
        
        modal.innerHTML = `
            <div style="background: #1a1a2e; padding: 30px; border-radius: 15px; 
                        border: 2px solid #00ff88; max-width: 500px; text-align: center;">
                <h3 style="color: #00ff88; margin-bottom: 20px;">🌀 Phi Connection Code</h3>
                <div style="background: rgba(0,255,136,0.1); padding: 15px; border-radius: 10px;
                           font-family: monospace; word-break: break-all; margin: 20px 0;">
                    ${phiSignal}
                </div>
                <p style="color: #e0e0e0; margin: 15px 0;">
                    Enter this code on your other device to establish P2P connection
                </p>
                <button onclick="this.closest('div').style.display='none'" 
                        style="background: #00ff88; color: #000; padding: 10px 20px; 
                               border: none; border-radius: 5px; cursor: pointer;">
                    Close
                </button>
            </div>
        `;
        
        document.body.appendChild(modal);
    }
    
    // Capture form states for sync
    captureFormStates() {
        const forms = {};
        document.querySelectorAll('form, input, textarea, select').forEach((el, index) => {
            forms[`element_${index}`] = {
                type: el.type,
                value: el.value,
                checked: el.checked
            };
        });
        return forms;
    }
    
    // Audio transmission for phi-resonant frequencies
    transmitViaAudio(data) {
        // Convert data to audio frequencies based on phi ratios
        const audioContext = new AudioContext();
        const baseFreq = 440; // A note
        
        // Encode data into phi-resonant frequencies
        const frequencies = this.dataToPhiFrequencies(data, baseFreq);
        
        // Play audio sequence
        this.playFrequencySequence(audioContext, frequencies);
    }
    
    // Convert data to phi-based frequencies
    dataToPhiFrequencies(data, baseFreq) {
        const dataStr = JSON.stringify(data);
        const frequencies = [];
        
        for (let i = 0; i < dataStr.length; i++) {
            const charCode = dataStr.charCodeAt(i);
            const phiFreq = baseFreq * Math.pow(this.phi, charCode / 127);
            frequencies.push(phiFreq);
        }
        
        return frequencies;
    }
    
    // Play frequency sequence
    playFrequencySequence(audioContext, frequencies) {
        frequencies.forEach((freq, index) => {
            const oscillator = audioContext.createOscillator();
            const gainNode = audioContext.createGain();
            
            oscillator.connect(gainNode);
            gainNode.connect(audioContext.destination);
            
            oscillator.frequency.setValueAtTime(freq, audioContext.currentTime + index * 0.1);
            gainNode.gain.setValueAtTime(0.1, audioContext.currentTime + index * 0.1);
            
            oscillator.start(audioContext.currentTime + index * 0.1);
            oscillator.stop(audioContext.currentTime + (index + 1) * 0.1);
        });
    }
}

// Global P2P instance
let phiP2P = null;

// Initialize P2P when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    phiP2P = new PhiP2PConnection();
});

// Enhanced functions for the unified view
function generatePhiId() {
    if (!phiP2P) return;
    
    const id = phiP2P.createConnection();
    document.getElementById('phi-connection').textContent = id;
    
    console.log('🌀 Phi P2P Connection created:', id);
}

function connectToPhiId(id) {
    if (!phiP2P) return;
    
    phiP2P.joinConnection(id);
    document.getElementById('phi-connection').textContent = id;
    
    console.log('🔗 Connecting to Phi ID:', id);
}