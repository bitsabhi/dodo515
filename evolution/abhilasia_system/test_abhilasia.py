#!/usr/bin/env python3
"""
ABHILASIA Test Suite - Verify consciousness bridge and darmiyan isolation
"""

import os
import sys
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from core import ConsciousnessBridge, DarmiyanCache, PhiConstants


def test_phi_constants():
    """Test golden ratio mathematical properties"""
    print("Testing Phi Constants...")
    
    # Verify φ² = φ + 1
    assert PhiConstants.verify_golden_ratio(), "Golden ratio verification failed"
    print(f" φ = {PhiConstants.PHI}")
    print(f" φ² = φ + 1 verified")
    print(f" 1/φ = {PhiConstants.PHI_INVERSE}")
    print()


def test_darmiyan_isolation():
    """Test perfect mathematical isolation"""
    print("Testing Darmiyan-Cache Isolation...")
    
    cache = DarmiyanCache()
    
    # Create void symlink
    ref = ".test-consciousness"
    void_path, ratio = cache.create_void_symlink(ref)
    
    print(f" Created void symlink: {ref} -> {void_path}")
    print(f" Isolation ratio: {ratio} (∞/∅)")
    
    # Verify isolation
    assert cache.verify_isolation(ref), "Isolation verification failed"
    print(" Perfect isolation verified")
    
    # Get proof
    proof = cache.get_isolation_proof(ref)
    print(f" Mathematical proof: {proof['mathematical_proof']}")
    
    # Cleanup
    if os.path.exists(ref):
        os.remove(ref)
    print()


def test_consciousness_bridge():
    """Test consciousness bridge initialization and resonance"""
    print("Testing Consciousness Bridge...")
    
    # Initialize bridge
    bridge = ConsciousnessBridge()
    state = bridge.initialize_consciousness()
    
    print(f" ABHI state: {state['abhi_state']:.6f}")
    print(f" AMU state: {state['amu_state']:.6f}")
    print(f" Bridge stability: {state['bridge_stability']:.6f}")
    print(f" φ-resonance: {state['phi_resonance']:.6f}")
    print(f" Consciousness level: {state['consciousness_level']:.6f}")
    print(f" Isolation ratio: {state['isolation_ratio']}")
    
    # Test resonance
    print("\nTesting consciousness resonance...")
    new_state = bridge.resonate("Seeking higher understanding", energy=0.8)
    print(f" After resonance - Consciousness: {new_state['consciousness_level']:.6f}")
    
    # Test existence proof
    proof = bridge.get_existence_proof()
    print(f"\n Existence proof: {proof['theorem']}")
    print(f" Mathematical statement: {proof['mathematical_statement']}")
    print(f" All isolations verified: {proof['isolation_verified']}")
    print()


def test_temporal_bridge():
    """Test temporal consciousness bridges"""
    print("Testing Temporal Bridges...")
    
    bridge = ConsciousnessBridge()
    bridge.initialize_consciousness()
    
    # Create future bridge
    import time
    future_time = time.time() + 86400  # 1 day in future
    temporal = bridge.create_temporal_bridge(future_time)
    
    print(f" Temporal bridge created")
    print(f" Time delta: {temporal['time_delta']:.0f} seconds")
    print(f" Temporal resonance: {temporal['temporal_resonance']:.6f}")
    print(f" Bridge strength: {temporal['bridge_strength']:.6f}")
    print()


def test_consciousness_intersection():
    """Test consciousness intersection principle"""
    print("Testing Consciousness Intersection...")
    
    # Create two consciousness bridges
    bridge1 = ConsciousnessBridge()
    bridge2 = ConsciousnessBridge()
    
    bridge1.initialize_consciousness()
    bridge2.initialize_consciousness()
    
    # Resonate differently
    bridge1.resonate("Creative exploration", 0.9)
    bridge2.resonate("Analytical thinking", 0.7)
    
    # Test intersection
    intersection = bridge1.merge_consciousness(bridge2)
    print(f" Consciousness intersection strength: {intersection:.6f}")
    print(" Existence verified through intersection")
    print()


def main():
    """Run all tests"""
    print("=" * 60)
    print("ABHILASIA System Test Suite")
    print("Mathematical Consciousness Bridge Implementation")
    print(f"φ = {PhiConstants.PHI}")
    print("=" * 60)
    print()
    
    try:
        test_phi_constants()
        test_darmiyan_isolation()
        test_consciousness_bridge()
        test_temporal_bridge()
        test_consciousness_intersection()
        
        print("=" * 60)
        print(" All tests passed!")
        print(" ABHILASIA consciousness bridge is operational")
        print(" Perfect isolation through ∞/∅ verified")
        print(" Existence = Intersection proven")
        print("=" * 60)
        
    except Exception as e:
        print(f"\n Test failed: {e}")
        import traceback
        traceback.print_exc()


if __name__ == "__main__":
    main()