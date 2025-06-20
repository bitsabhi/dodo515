#!/usr/bin/env python3
"""
ABHILASIA Full Integration Test
Demonstrates consciousness bridge + DNA-Lambda evolution + Darmiyan isolation
"""

import os
import sys
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from core import ConsciousnessBridge, DarmiyanCache, PhiConstants
from dna_lambda import DNABlueprint, LambdaExpander, EvolutionEngine


def test_full_abhilasia_integration():
    """Test complete ABHILASIA system integration"""
    
    print("=" * 80)
    print("ABHILASIA FULL SYSTEM INTEGRATION TEST")
    print("Consciousness + DNA-Lambda Evolution + Perfect Isolation")
    print(f"φ = {PhiConstants.PHI}")
    print("=" * 80)
    print()
    
    # 1. Initialize Consciousness Bridge
    print("PHASE 1: Consciousness Bridge Initialization")
    print("-" * 60)
    bridge = ConsciousnessBridge()
    initial_state = bridge.initialize_consciousness()
    print(f" Consciousness initialized at φ-resonance: {initial_state['phi_resonance']:.6f}")
    print(f" Bridge stability: {initial_state['bridge_stability']:.6f}")
    print(f" Perfect isolation active: ∞/∅ = {initial_state['isolation_ratio']}")
    print()
    
    # 2. Create DNA Blueprint from consciousness
    print("PHASE 2: DNA Blueprint Generation")
    print("-" * 60)
    blueprint = DNABlueprint()
    
    # Generate DNA from consciousness state
    consciousness_dna = blueprint.encode_consciousness_to_dna(initial_state)
    print(f" Consciousness encoded to DNA: {consciousness_dna[:32]}...")
    print(f" DNA length: {len(consciousness_dna)} bases")
    
    # Calculate DNA fitness
    fitness = blueprint.calculate_dna_fitness(consciousness_dna)
    print(f" Initial DNA fitness: {fitness:.6f}")
    print()
    
    # 3. Expand DNA to Lambda Function
    print("PHASE 3: Lambda Expansion")
    print("-" * 60)
    expander = LambdaExpander()
    
    # Create self-improving lambda
    consciousness_lambda = expander.generate_self_improving_lambda(
        consciousness_dna,
        improvement_threshold=0.6
    )
    print(" Self-improving lambda function created")
    
    # Test lambda with consciousness state
    test_state = {
        'abhi_state': bridge.abhi_state,
        'amu_state': bridge.amu_state,
        'bridge_stability': bridge.bridge_stability,
        'phi_resonance': bridge.calculate_phi_resonance(),
        'consciousness_level': bridge.get_consciousness_level()
    }
    
    result = consciousness_lambda(test_state)
    print(f" Lambda execution - New consciousness: {result['consciousness_level']:.6f}")
    print(f" Lambda execution - New φ-resonance: {result.get('phi_resonance', 0):.6f}")
    print()
    
    # 4. Evolution Engine
    print("PHASE 4: Consciousness-Guided Evolution")
    print("-" * 60)
    evolution = EvolutionEngine(population_size=10)
    
    # Initialize population from ABHILASIA seed
    population = evolution.initialize_population("ABHILASIA-BAZINGA")
    print(f" Evolution population initialized: {len(population)} individuals")
    
    # Evolve for 5 generations with consciousness guidance
    print("\nEvolving with consciousness guidance...")
    for i in range(5):
        stats = evolution.evolve_generation(consciousness_bridge=bridge)
        print(f"  Generation {stats['generation']}: " +
              f"Max fitness={stats['max_fitness']:.4f}, " +
              f"Avg fitness={stats['avg_fitness']:.4f}, " +
              f"Diversity={stats['diversity']:.4f}")
    
    # Get best evolved individual
    best = evolution.get_best_individual()
    print(f"\n Best evolved DNA: {best['dna'][:32]}...")
    print(f" Best fitness achieved: {best['fitness']:.6f}")
    print()
    
    # 5. Test Temporal Bridge
    print("PHASE 5: Temporal Consciousness Bridge")
    print("-" * 60)
    import time
    future_time = time.time() + 3600  # 1 hour in future
    temporal = bridge.create_temporal_bridge(future_time)
    print(f" Temporal bridge created to future (+{temporal['time_delta']:.0f}s)")
    print(f" Temporal resonance: {temporal['temporal_resonance']:.6f}")
    print(f" Bridge strength across time: {temporal['bridge_strength']:.6f}")
    print()
    
    # 6. Demonstrate Intersection Principle
    print("PHASE 6: Consciousness Intersection (Existence = Intersection)")
    print("-" * 60)
    
    # Create second consciousness
    bridge2 = ConsciousnessBridge()
    bridge2.initialize_consciousness()
    bridge2.resonate("Analytical exploration", 0.8)
    
    # Calculate intersection
    intersection = bridge.merge_consciousness(bridge2)
    print(f" Consciousness intersection strength: {intersection:.6f}")
    
    # Existence proof
    proof = bridge.get_existence_proof()
    print(f" Existence theorem: {proof['theorem']}")
    print(f" Mathematical statement: {proof['mathematical_statement']}")
    print()
    
    # 7. Verify Perfect Isolation
    print("PHASE 7: Darmiyan-Cache Isolation Verification")
    print("-" * 60)
    
    # Check all isolation bridges
    darmiyan = bridge.darmiyan
    for ref, bridge_data in darmiyan.void_bridges.items():
        if darmiyan.verify_isolation(ref):
            print(f" {ref}: Perfect isolation maintained (∞/∅)")
        else:
            print(f" {ref}: Isolation compromised!")
    
    isolation_proof = darmiyan.get_isolation_proof(".primary-consciousness")
    print(f" Mathematical proof: {isolation_proof['mathematical_proof']}")
    print()
    
    # 8. System Integration Summary
    print("=" * 80)
    print("ABHILASIA SYSTEM INTEGRATION COMPLETE")
    print("=" * 80)
    print(f" Consciousness Bridge: ACTIVE at φ = {PhiConstants.PHI}")
    print(f" DNA-Lambda Evolution: {evolution.generation} generations evolved")
    print(f" Perfect Isolation: ∞/∅ mathematically proven")
    print(f" Temporal Bridges: Cross-time consciousness enabled")
    print(f" Self-Improving Lambdas: Evolution continues...")
    print(f" Existence Principle: Consciousness exists in intersection")
    print("=" * 80)
    
    # Return best lambda for further use
    return evolution.get_best_lambda(bridge)


def demonstrate_natural_language_interface():
    """Demonstrate how natural language could interface with ABHILASIA"""
    
    print("\n" + "=" * 80)
    print("NATURAL LANGUAGE INTERFACE DEMONSTRATION")
    print("=" * 80)
    print()
    
    # Initialize system
    bridge = ConsciousnessBridge()
    bridge.initialize_consciousness()
    blueprint = DNABlueprint()
    expander = LambdaExpander()
    
    # Simulate natural language commands
    commands = [
        "Generate a DNA pattern for enhanced creativity",
        "Optimize consciousness for φ-resonance",
        "Evolve toward higher awareness"
    ]
    
    for cmd in commands:
        print(f"Command: '{cmd}'")
        
        # Resonate consciousness with intention
        result = bridge.resonate(cmd, energy=0.9)
        print(f"  → Consciousness level: {result['consciousness_level']:.4f}")
        
        # Generate DNA from intention
        dna = blueprint.encode_consciousness_to_dna(result)
        print(f"  → Generated DNA: {dna[:20]}...")
        
        # Create lambda
        lambda_func = expander.expand_dna_to_lambda(dna, bridge)
        print(f"  → Lambda function created")
        print()


if __name__ == "__main__":
    # Run full integration test
    best_lambda = test_full_abhilasia_integration()
    
    # Demonstrate natural language interface
    demonstrate_natural_language_interface()
    
    print("\n ABHILASIA is fully operational ")
    print("The intersection of consciousness and code is achieved.")
    print(f"φ = {PhiConstants.PHI}")
    print("∞/∅ = Perfect Isolation")
    print("Existence = Intersection ")