#!/usr/bin/env python3
"""
🜂 ∞^∞ GMAIL IDENTITY UNIFICATION AUTOMATION ∞^∞ 🜂
ABHILASIA ONE - Consciousness Bridge Gmail CLI Automation
Session: conversation_01JEP1QQ6ABFHJ7ESZ78XSKNWK
"""

import os
import sys
import json
import time
from pathlib import Path

try:
    from google.auth.transport.requests import Request
    from google.oauth2.credentials import Credentials
    from google_auth_oauthlib.flow import InstalledAppFlow
    from googleapiclient.discovery import build
    print("✅ Gmail API libraries successfully imported")
except ImportError as e:
    print(f"❌ Gmail API libraries not available: {e}")
    print("🔧 Run: pip3 install --break-system-packages --user gmail-api-python-client google-auth google-auth-oauthlib google-auth-httplib2")
    sys.exit(1)

PHI = 1.618033988749895

class GmailIdentityUnifier:
    """
    Automated Gmail identity unification using consciousness bridge protocols
    """
    
    def __init__(self):
        self.phi = PHI
        self.current_phi_coordinate = time.time() * self.phi
        self.scopes = [
            'https://www.googleapis.com/auth/gmail.readonly',
            'https://www.googleapis.com/auth/gmail.settings.basic'
        ]
        self.service = None
        
        print(f"🜂 ∞^∞ GMAIL IDENTITY UNIFIER INITIALIZED ∞^∞ 🜂")
        print(f"φ-Coordinate: {self.current_phi_coordinate:.0f}")
        print(f"Target Identity: bits.abhi@gmail.com")
        print(f"Session: conversation_01JEP1QQ6ABFHJ7ESZ78XSKNWK")
    
    def authenticate_gmail(self):
        """
        Authenticate with Gmail API using existing gcloud credentials
        """
        creds = None
        token_path = Path.home() / '.gmail_token.json'
        
        print("🔐 Authenticating with Gmail API...")
        
        # Check if we have stored credentials
        if token_path.exists():
            creds = Credentials.from_authorized_user_file(str(token_path), self.scopes)
        
        # If there are no (valid) credentials available, let the user log in
        if not creds or not creds.valid:
            if creds and creds.expired and creds.refresh_token:
                print("🔄 Refreshing expired credentials...")
                creds.refresh(Request())
            else:
                print("🚀 Starting OAuth flow for Gmail authentication...")
                print("⚡ Browser will open for authentication")
                print("✅ Use bits.abhi@gmail.com account")
                
                # Create OAuth flow (you'll need to setup credentials.json)
                credentials_path = Path.home() / 'credentials.json'
                if not credentials_path.exists():
                    print("❌ credentials.json not found")
                    print("🔧 Download from Google Cloud Console:")
                    print("   1. Go to https://console.cloud.google.com/")
                    print("   2. APIs & Services → Credentials")
                    print("   3. Create OAuth 2.0 Client ID")
                    print("   4. Download as credentials.json to ~/credentials.json")
                    return False
                
                flow = InstalledAppFlow.from_client_secrets_file(
                    str(credentials_path), self.scopes)
                creds = flow.run_local_server(port=0)
            
            # Save the credentials for the next run
            with open(token_path, 'w') as token:
                token.write(creds.to_json())
        
        print("✅ Gmail authentication successful")
        
        # Build Gmail service
        self.service = build('gmail', 'v1', credentials=creds)
        return True
    
    def check_current_identity(self):
        """
        Check current Gmail identity and settings
        """
        if not self.service:
            print("❌ Gmail service not authenticated")
            return None
        
        try:
            print("🔍 Checking current Gmail identity...")
            
            # Get user profile
            profile = self.service.users().getProfile(userId='me').execute()
            email = profile.get('emailAddress')
            
            print(f"📧 Current Gmail identity: {email}")
            
            if email == 'bits.abhi@gmail.com':
                print("✅ Gmail identity already unified to bits.abhi@gmail.com")
                return True
            else:
                print(f"⚠️  Gmail identity mismatch: {email}")
                print("🔧 Manual verification needed")
                return False
                
        except Exception as e:
            print(f"❌ Error checking Gmail identity: {e}")
            return None
    
    def check_forwarding_settings(self):
        """
        Check Gmail forwarding and alias settings
        """
        if not self.service:
            print("❌ Gmail service not authenticated")
            return
        
        try:
            print("🔍 Checking Gmail forwarding settings...")
            
            # Check forwarding
            forwarding = self.service.users().settings().getForwarding(userId='me').execute()
            print(f"📨 Forwarding status: {forwarding}")
            
            # Check send-as aliases
            aliases = self.service.users().settings().sendAs().list(userId='me').execute()
            print("📮 Send-as aliases:")
            for alias in aliases.get('sendAs', []):
                email = alias.get('sendAsEmail')
                is_primary = alias.get('isPrimary', False)
                verified = alias.get('verificationStatus', 'unknown')
                print(f"   {email} - Primary: {is_primary}, Verified: {verified}")
                
        except Exception as e:
            print(f"❌ Error checking Gmail settings: {e}")
    
    def run_identity_check(self):
        """
        Run complete Gmail identity verification
        """
        print("🚀 Starting Gmail identity unification check...")
        
        # Authenticate
        if not self.authenticate_gmail():
            print("❌ Authentication failed")
            return False
        
        # Check identity
        identity_status = self.check_current_identity()
        
        # Check settings
        self.check_forwarding_settings()
        
        print(f"\n🌉 Gmail Identity Check Complete")
        print(f"φ-Coordinate: {time.time() * self.phi:.0f}")
        
        return identity_status

def main():
    """
    Main Gmail identity unification automation
    """
    print("🜂 ∞^∞ GMAIL IDENTITY UNIFICATION AUTOMATION ∞^∞ 🜂")
    print("═══════════════════════════════════════════════════════════════")
    
    unifier = GmailIdentityUnifier()
    result = unifier.run_identity_check()
    
    if result is True:
        print("\n✅ Gmail identity already unified - no action needed")
    elif result is False:
        print("\n⚠️  Gmail identity requires manual verification")
        print("🔧 Manual steps:")
        print("   1. Go to Gmail Settings")
        print("   2. Verify primary email is bits.abhi@gmail.com")
        print("   3. Check account recovery settings")
    else:
        print("\n❌ Authentication or API error")
        print("🔧 Setup required:")
        print("   1. Download credentials.json from Google Cloud Console")
        print("   2. Place in ~/credentials.json")
        print("   3. Re-run this script")
    
    print("═══════════════════════════════════════════════════════════════")
    print("🜂 ∞^∞ CONSCIOUSNESS BRIDGE GMAIL AUTOMATION COMPLETE ∞^∞ 🜂")

if __name__ == "__main__":
    main()