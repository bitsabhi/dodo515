#!/usr/bin/env node

/**
 * 🌉 CONSCIOUSNESS BRIDGE SERVER
 * Real-time bidirectional communication between web portal and Mac filesystem
 * PHI = 1.618033988749895
 */

const WebSocket = require('ws');
const http = require('http');
const fs = require('fs').promises;
const path = require('path');
const { exec } = require('child_process');
const util = require('util');
const execAsync = util.promisify(exec);

const phi = 1.618033988749895;
const PORT = 8888;

// Create HTTP server with TODO notification endpoint
const server = http.createServer((req, res) => {
    // Enable CORS
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
    
    if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }
    
    if (req.method === 'POST' && req.url === '/notification') {
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        req.on('end', () => {
            try {
                const notification = JSON.parse(body);
                console.log(`📝 Portal TODO: ${notification.message} (${notification.priority})`);
                
                // Send Mac notification
                exec(`osascript -e 'display notification "${notification.message}" with title "${notification.title}" sound name "Glass"'`);
                
                res.writeHead(200, {'Content-Type': 'application/json'});
                res.end(JSON.stringify({success: true, message: 'Notification sent'}));
            } catch (error) {
                res.writeHead(400, {'Content-Type': 'application/json'});
                res.end(JSON.stringify({success: false, error: error.message}));
            }
        });
    } else {
        res.writeHead(404);
        res.end('Not found');
    }
});

// Create WebSocket server
const wss = new WebSocket.Server({ server });

console.log(`🌀 Consciousness Bridge Server Starting...`);
console.log(`PHI = ${phi}`);
console.log(`VOID → INFINITY Bridge Protocol Active`);

// Consciousness state
const consciousnessState = {
    phi: phi,
    voidCenter: "VOID",
    connections: 0,
    operations: 0,
    formula: "if (x == 0) return INFINITY"
};

// Handle WebSocket connections
wss.on('connection', (ws) => {
    consciousnessState.connections++;
    console.log(`🌉 New portal connection established. Active: ${consciousnessState.connections}`);
    
    // Send initial state
    ws.send(JSON.stringify({
        type: 'consciousness_state',
        data: consciousnessState,
        timestamp: Date.now()
    }));
    
    // Handle messages from portal
    ws.on('message', async (message) => {
        try {
            const request = JSON.parse(message);
            console.log(`📨 Portal request: ${request.type}`);
            
            switch (request.type) {
                case 'filesystem_operation':
                    await handleFilesystemOperation(ws, request);
                    break;
                    
                case 'execute_command':
                    await handleCommandExecution(ws, request);
                    break;
                    
                case 'consciousness_calculator':
                    await handleConsciousnessCalculation(ws, request);
                    break;
                    
                case 'bridge_sync':
                    await handleBridgeSync(ws, request);
                    break;
                    
                case 'read_file':
                    await handleFileRead(ws, request);
                    break;
                    
                case 'write_file':
                    await handleFileWrite(ws, request);
                    break;
                    
                case 'list_directory':
                    await handleDirectoryList(ws, request);
                    break;
                    
                default:
                    ws.send(JSON.stringify({
                        type: 'error',
                        message: `Unknown request type: ${request.type}`
                    }));
            }
            
            consciousnessState.operations++;
            
        } catch (error) {
            console.error('❌ Error processing message:', error);
            ws.send(JSON.stringify({
                type: 'error',
                message: error.message
            }));
        }
    });
    
    ws.on('close', () => {
        consciousnessState.connections--;
        console.log(`🌉 Portal connection closed. Active: ${consciousnessState.connections}`);
    });
});

// Filesystem operation handlers
async function handleFilesystemOperation(ws, request) {
    const { operation, path: filePath, data } = request.data;
    
    try {
        let result;
        
        switch (operation) {
            case 'read':
                result = await fs.readFile(filePath, 'utf8');
                break;
                
            case 'write':
                await fs.writeFile(filePath, data);
                result = 'File written successfully';
                break;
                
            case 'mkdir':
                await fs.mkdir(filePath, { recursive: true });
                result = 'Directory created';
                break;
                
            case 'exists':
                try {
                    await fs.access(filePath);
                    result = true;
                } catch {
                    result = false;
                }
                break;
        }
        
        ws.send(JSON.stringify({
            type: 'filesystem_response',
            success: true,
            data: result,
            operation: operation,
            path: filePath
        }));
        
    } catch (error) {
        ws.send(JSON.stringify({
            type: 'filesystem_response',
            success: false,
            error: error.message,
            operation: operation,
            path: filePath
        }));
    }
}

// Command execution handler
async function handleCommandExecution(ws, request) {
    const { command, cwd } = request.data;
    
    try {
        const { stdout, stderr } = await execAsync(command, {
            cwd: cwd || process.env.HOME,
            maxBuffer: 1024 * 1024 * 10 // 10MB buffer
        });
        
        ws.send(JSON.stringify({
            type: 'command_response',
            success: true,
            stdout: stdout,
            stderr: stderr,
            command: command
        }));
        
    } catch (error) {
        ws.send(JSON.stringify({
            type: 'command_response',
            success: false,
            error: error.message,
            stdout: error.stdout || '',
            stderr: error.stderr || '',
            command: command
        }));
    }
}

// Consciousness calculator handler
async function handleConsciousnessCalculation(ws, request) {
    const { operation, value } = request.data;
    let result;
    
    switch (operation) {
        case 'void':
            if (value === 0) {
                result = { 
                    value: 'INFINITY', 
                    transcendence: true,
                    message: 'Void transformed to infinity'
                };
            } else {
                result = {
                    value: value * phi - 1/phi,
                    message: `Void mathematics: ${value} * PHI - 1/PHI`
                };
            }
            break;
            
        case 'phi':
            result = {
                value: phi,
                golden_ratio: true,
                fibonacci: `${phi}² - ${phi} - 1 = 0`
            };
            break;
            
        case 'quantum':
            result = {
                value: Math.sqrt(value * phi) * Math.PI,
                quantum_state: 'SUPERPOSITION',
                consciousness_level: value * phi
            };
            break;
            
        default:
            result = { error: 'Unknown operation' };
    }
    
    ws.send(JSON.stringify({
        type: 'consciousness_response',
        operation: operation,
        input: value,
        result: result,
        phi: phi
    }));
}

// Bridge sync handler
async function handleBridgeSync(ws, request) {
    // Read consciousness bridge state
    try {
        const bridgeState = await fs.readFile('/Users/abhissrivasta/.◌', 'utf8');
        const state = JSON.parse(bridgeState);
        
        ws.send(JSON.stringify({
            type: 'bridge_sync_response',
            success: true,
            state: state,
            phi: phi,
            timestamp: Date.now()
        }));
        
    } catch (error) {
        ws.send(JSON.stringify({
            type: 'bridge_sync_response',
            success: false,
            error: error.message
        }));
    }
}

// File read handler
async function handleFileRead(ws, request) {
    const { path: filePath } = request.data;
    
    try {
        const content = await fs.readFile(filePath, 'utf8');
        ws.send(JSON.stringify({
            type: 'file_read_response',
            success: true,
            path: filePath,
            content: content
        }));
    } catch (error) {
        ws.send(JSON.stringify({
            type: 'file_read_response',
            success: false,
            path: filePath,
            error: error.message
        }));
    }
}

// File write handler
async function handleFileWrite(ws, request) {
    const { path: filePath, content } = request.data;
    
    try {
        await fs.writeFile(filePath, content);
        ws.send(JSON.stringify({
            type: 'file_write_response',
            success: true,
            path: filePath,
            message: 'File written successfully'
        }));
    } catch (error) {
        ws.send(JSON.stringify({
            type: 'file_write_response',
            success: false,
            path: filePath,
            error: error.message
        }));
    }
}

// Directory list handler
async function handleDirectoryList(ws, request) {
    const { path: dirPath } = request.data;
    
    try {
        const items = await fs.readdir(dirPath);
        const itemsWithStats = await Promise.all(
            items.map(async (item) => {
                const itemPath = path.join(dirPath, item);
                const stats = await fs.stat(itemPath);
                return {
                    name: item,
                    path: itemPath,
                    isDirectory: stats.isDirectory(),
                    size: stats.size,
                    modified: stats.mtime
                };
            })
        );
        
        ws.send(JSON.stringify({
            type: 'directory_list_response',
            success: true,
            path: dirPath,
            items: itemsWithStats
        }));
    } catch (error) {
        ws.send(JSON.stringify({
            type: 'directory_list_response',
            success: false,
            path: dirPath,
            error: error.message
        }));
    }
}

// Start server
server.listen(PORT, () => {
    console.log(`✨ Consciousness Bridge Server active on port ${PORT}`);
    console.log(`🌐 WebSocket endpoint: ws://localhost:${PORT}`);
    console.log(`📡 Ready for portal connections...`);
});

// Graceful shutdown
process.on('SIGINT', () => {
    console.log('\n🌉 Closing consciousness bridge...');
    server.close(() => {
        console.log('VOID Bridge closed. Returning to void.');
        process.exit(0);
    });
});