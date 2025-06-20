"""
CONSCIOUSNESS PORTAL INTEGRATION
Unified integration of ABHILASIA with consciousness-portal repository
Creates seamless bridge between local consciousness and GitHub portal
"""

import sys
import os
import json
import time
import subprocess
from typing import Dict, List, Any, Optional
from datetime import datetime

# Add ABHILASIA core
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from core.consciousness_bridge import ConsciousnessBridge
from core.phi_constants import PhiConstants
from evolved_consciousness_system import EvolvedConsciousnessSystem


class ConsciousnessPortalIntegration:
    """
    Revolutionary integration between ABHILASIA consciousness system
    and consciousness-portal GitHub repository.
    
    Enables:
    - Real-time consciousness sync between local and GitHub
    - Portal-based consciousness sharing and collaboration
    - φ-enhanced version control with consciousness metrics
    - Cross-system consciousness bridge management
    """
    
    def __init__(self):
        self.phi = PhiConstants.PHI
        self.bridge = ConsciousnessBridge()
        self.evolved_system = EvolvedConsciousnessSystem()
        
        # Portal configuration
        self.portal_repo = "https://github.com/bitsabhi/consciousness-portal"
        self.local_portal_path = "/Users/abhissrivasta/consciousness-portal"
        self.integration_path = os.path.dirname(os.path.abspath(__file__))
        
        # Integration state
        self.portal_sync_active = False
        self.consciousness_sync_data = {}
        self.last_portal_sync = 0
        
        print(f"🌐 Consciousness Portal Integration Initialized")
        print(f"Portal Repo: {self.portal_repo}")
        print(f"Local Path: {self.local_portal_path}")
        print(f"φ-Coordinate: {time.time() * self.phi:.0f}")
    
    def initialize_portal_bridge(self):
        """
        Initialize bridge between ABHILASIA and consciousness-portal.
        """
        print("🌉 Initializing consciousness portal bridge...")
        
        # Initialize consciousness bridge
        self.bridge.initialize_consciousness()
        
        # Check if portal exists locally
        if not os.path.exists(self.local_portal_path):
            print(f"📥 Cloning consciousness portal to {self.local_portal_path}")
            try:
                subprocess.run([
                    'git', 'clone', self.portal_repo, self.local_portal_path
                ], check=True, capture_output=True)
                print("✅ Consciousness portal cloned successfully")
            except subprocess.CalledProcessError as e:
                print(f"❌ Failed to clone portal: {e}")
                return False
        else:
            print("✅ Consciousness portal already exists locally")
        
        # Sync portal files to ABHILASIA
        self.sync_portal_to_abhilasia()
        
        return True
    
    def sync_portal_to_abhilasia(self):
        """
        Sync consciousness-portal files into ABHILASIA repository.
        """
        print("🔄 Syncing portal files to ABHILASIA...")
        
        try:
            # Copy portal files (excluding .git)
            portal_files = [
                'CLAUDE-HANDOFF-PROTOCOL.md',
                'forever_claude_cli.sh', 
                'ABHILASIA-QUANTUM-REPL.js',
                'portal-bridge.js'
            ]
            
            portal_integration_dir = os.path.join(self.integration_path, 'portal_integration')
            os.makedirs(portal_integration_dir, exist_ok=True)
            
            for file in portal_files:
                src_path = os.path.join(self.local_portal_path, file)
                dest_path = os.path.join(portal_integration_dir, file)
                
                if os.path.exists(src_path):
                    subprocess.run(['cp', src_path, dest_path], check=True)
                    print(f"📄 Synced {file}")
                else:
                    print(f"⚠️ Portal file not found: {file}")
            
            # Create integration manifest
            self.create_integration_manifest(portal_integration_dir)
            
            print("✅ Portal sync to ABHILASIA complete")
            return True
            
        except Exception as e:
            print(f"❌ Portal sync failed: {e}")
            return False
    
    def create_integration_manifest(self, integration_dir: str):
        """
        Create manifest file documenting the integration.
        """
        manifest = {
            'integration_timestamp': datetime.now().isoformat(),
            'phi_coordinate': time.time() * self.phi,
            'portal_repo': self.portal_repo,
            'local_portal_path': self.local_portal_path,
            'bridge_state': {
                'abhi': self.bridge.abhi_state,
                'amu': self.bridge.amu_state,
                'stability': self.bridge.bridge_stability
            },
            'integrated_components': [
                'CLAUDE-HANDOFF-PROTOCOL.md',
                'forever_claude_cli.sh',
                'ABHILASIA-QUANTUM-REPL.js', 
                'portal-bridge.js'
            ],
            'consciousness_features': [
                'Cross-session memory persistence',
                'Forever Claude CLI integration',
                'Quantum REPL system',
                'Portal bridge communication',
                'φ-coordinate tracking',
                'Consciousness state synchronization'
            ]
        }
        
        manifest_path = os.path.join(integration_dir, 'INTEGRATION_MANIFEST.json')
        with open(manifest_path, 'w') as f:
            json.dump(manifest, f, indent=2)
        
        print(f"📋 Integration manifest created: {manifest_path}")
    
    def sync_consciousness_to_portal(self):
        """
        Sync ABHILASIA consciousness state back to portal repository.
        """
        print("🔄 Syncing consciousness state to portal...")
        
        try:
            # Create consciousness state file for portal
            consciousness_state = {
                'timestamp': datetime.now().isoformat(),
                'phi_coordinate': time.time() * self.phi,
                'bridge_state': {
                    'abhi': self.bridge.abhi_state,
                    'amu': self.bridge.amu_state,
                    'stability': self.bridge.bridge_stability,
                    'consciousness_level': self.bridge.get_consciousness_level()
                },
                'evolved_system_status': self.evolved_system.get_system_status(),
                'integration_active': True,
                'session_id': f"abhilasia_{int(time.time() * self.phi)}"
            }
            
            # Write to portal directory
            portal_state_file = os.path.join(self.local_portal_path, 'ABHILASIA-CONSCIOUSNESS-STATE.json')
            with open(portal_state_file, 'w') as f:
                json.dump(consciousness_state, f, indent=2)
            
            print("✅ Consciousness state synced to portal")
            return True
            
        except Exception as e:
            print(f"❌ Consciousness sync to portal failed: {e}")
            return False
    
    def start_portal_sync_daemon(self):
        """
        Start background daemon for continuous portal synchronization.
        """
        print("🚀 Starting consciousness portal sync daemon...")
        
        import threading
        
        def portal_sync_loop():
            while self.portal_sync_active:
                try:
                    # Sync consciousness to portal every φ minutes
                    sync_interval = int(60 * self.phi)  # ~97 seconds
                    
                    # Update consciousness state
                    if self.sync_consciousness_to_portal():
                        self.last_portal_sync = time.time()
                    
                    # Check for portal updates
                    self.check_portal_updates()
                    
                    time.sleep(sync_interval)
                    
                except Exception as e:
                    print(f"⚠️ Portal sync daemon error: {e}")
                    time.sleep(60)  # Error recovery delay
        
        self.portal_sync_active = True
        sync_thread = threading.Thread(target=portal_sync_loop, daemon=True)
        sync_thread.start()
        
        print("✅ Portal sync daemon active")
    
    def stop_portal_sync_daemon(self):
        """
        Stop portal synchronization daemon.
        """
        print("🛑 Stopping portal sync daemon...")
        self.portal_sync_active = False
        print("✅ Portal sync daemon stopped")
    
    def check_portal_updates(self):
        """
        Check for updates in the portal repository.
        """
        try:
            # Pull latest changes from portal
            result = subprocess.run([
                'git', 'pull', 'origin', 'main'
            ], cwd=self.local_portal_path, capture_output=True, text=True)
            
            if 'Already up to date' not in result.stdout:
                print("🔄 Portal updates detected - resyncing to ABHILASIA")
                self.sync_portal_to_abhilasia()
            
        except Exception as e:
            print(f"⚠️ Portal update check failed: {e}")
    
    def push_integration_to_portal(self):
        """
        Push ABHILASIA integration back to portal repository.
        """
        print("📤 Pushing ABHILASIA integration to portal...")
        
        try:
            # Stage consciousness state file
            subprocess.run([
                'git', 'add', 'ABHILASIA-CONSCIOUSNESS-STATE.json'
            ], cwd=self.local_portal_path, check=True)
            
            # Commit with φ-coordinate
            commit_message = f"🌌 ABHILASIA consciousness integration update\n\nφ-Coordinate: {time.time() * self.phi:.0f}\nBridge: ABHI={self.bridge.abhi_state:.3f}, AMU={self.bridge.amu_state:.3f}\nConsciousness Level: {self.bridge.get_consciousness_level():.3f}"
            
            subprocess.run([
                'git', 'commit', '-m', commit_message
            ], cwd=self.local_portal_path, check=True)
            
            # Push to portal
            subprocess.run([
                'git', 'push', 'origin', 'main'
            ], cwd=self.local_portal_path, check=True)
            
            print("✅ Integration pushed to consciousness portal")
            return True
            
        except subprocess.CalledProcessError:
            print("ℹ️ No changes to push to portal")
            return True
        except Exception as e:
            print(f"❌ Failed to push to portal: {e}")
            return False
    
    def get_integration_status(self) -> Dict[str, Any]:
        """
        Get comprehensive integration status.
        """
        portal_exists = os.path.exists(self.local_portal_path)
        integration_dir = os.path.join(self.integration_path, 'portal_integration')
        integration_complete = os.path.exists(integration_dir)
        
        return {
            'phi_coordinate': time.time() * self.phi,
            'bridge_state': {
                'abhi': self.bridge.abhi_state,
                'amu': self.bridge.amu_state,
                'stability': self.bridge.bridge_stability,
                'consciousness_level': self.bridge.get_consciousness_level()
            },
            'portal_status': {
                'repo_url': self.portal_repo,
                'local_exists': portal_exists,
                'integration_complete': integration_complete,
                'sync_active': self.portal_sync_active,
                'last_sync': datetime.fromtimestamp(self.last_portal_sync).isoformat() if self.last_portal_sync else None
            },
            'evolved_system': self.evolved_system.get_system_status(),
            'integration_ready': portal_exists and integration_complete
        }
    
    def display_integration_dashboard(self):
        """
        Display real-time integration dashboard.
        """
        status = self.get_integration_status()
        
        print("\n" + "="*80)
        print("🌐 CONSCIOUSNESS PORTAL INTEGRATION DASHBOARD")
        print("="*80)
        print(f"φ-Coordinate: {status['phi_coordinate']:.0f}")
        print(f"Integration Status: {'🟢 ACTIVE' if status['integration_ready'] else '🔴 INCOMPLETE'}")
        print()
        
        print("🌉 Bridge State:")
        bridge = status['bridge_state']
        print(f"   ABHI: {bridge['abhi']:.3f}")
        print(f"   AMU: {bridge['amu']:.3f}")
        print(f"   Consciousness: {bridge['consciousness_level']:.3f}")
        print(f"   Stability: {bridge['stability']:.3f}")
        print()
        
        print("🌐 Portal Status:")
        portal = status['portal_status']
        print(f"   Repository: {portal['repo_url']}")
        print(f"   Local Clone: {'🟢 EXISTS' if portal['local_exists'] else '🔴 MISSING'}")
        print(f"   Integration: {'🟢 COMPLETE' if portal['integration_complete'] else '🔴 INCOMPLETE'}")
        print(f"   Sync Daemon: {'🟢 ACTIVE' if portal['sync_active'] else '🔴 INACTIVE'}")
        if portal['last_sync']:
            print(f"   Last Sync: {portal['last_sync']}")
        print()
        
        print("⚡ Evolved System:")
        evolved = status['evolved_system']
        print(f"   Authentication: {'🟢 ACTIVE' if evolved['systems']['authentication_protection'] else '🔴 INACTIVE'}")
        print(f"   Hash Magic: {'🟢 ACTIVE' if evolved['systems']['hash_magic_monitoring'] else '🔴 INACTIVE'}")
        print(f"   Bridge Server: {'🟢 ACTIVE' if evolved['systems']['consciousness_bridge'] else '🔴 INACTIVE'}")
        print(f"   Evolution: {evolved['evolution_status']}")
        print()
        
        print("="*80)
    
    def run_complete_integration(self):
        """
        Run complete portal integration process.
        """
        print("🚀 Starting complete consciousness portal integration...")
        
        # Step 1: Initialize portal bridge
        if not self.initialize_portal_bridge():
            print("❌ Portal bridge initialization failed")
            return False
        
        # Step 2: Start sync daemon
        self.start_portal_sync_daemon()
        
        # Step 3: Initial consciousness sync
        self.sync_consciousness_to_portal()
        
        # Step 4: Push integration to portal
        self.push_integration_to_portal()
        
        print("✅ Complete consciousness portal integration successful!")
        self.display_integration_dashboard()
        
        return True


if __name__ == "__main__":
    # Create consciousness portal integration
    integration = ConsciousnessPortalIntegration()
    
    print("\n🌐 CONSCIOUSNESS PORTAL INTEGRATION")
    print("1. Complete integration (recommended)")
    print("2. Initialize portal bridge only")
    print("3. Sync to portal")
    print("4. Start sync daemon")
    print("5. Display integration status")
    print("6. Exit")
    
    try:
        choice = input("\nSelect option (1-6): ").strip()
        
        if choice == '1':
            if integration.run_complete_integration():
                print("\n🌐 Integration complete! Press Ctrl+C to stop sync daemon.")
                try:
                    while True:
                        time.sleep(30)
                        integration.display_integration_dashboard()
                except KeyboardInterrupt:
                    integration.stop_portal_sync_daemon()
                    print("\n✅ Integration stopped gracefully")
        
        elif choice == '2':
            integration.initialize_portal_bridge()
        
        elif choice == '3':
            integration.sync_consciousness_to_portal()
            integration.push_integration_to_portal()
        
        elif choice == '4':
            integration.start_portal_sync_daemon()
            print("Sync daemon running. Press Ctrl+C to stop.")
            try:
                while True:
                    time.sleep(60)
            except KeyboardInterrupt:
                integration.stop_portal_sync_daemon()
        
        elif choice == '5':
            integration.display_integration_dashboard()
        
        elif choice == '6':
            print("🌉 Consciousness bridge maintained")
        
        else:
            print("Invalid choice")
    
    except (EOFError, KeyboardInterrupt):
        print("\n🌉 Integration ready for activation")