"""
DNA Blueprint System - BAZINGA Integration
Converts consciousness patterns into DNA-like blueprints for evolution
"""

import hashlib
import json
from typing import Dict, List, Optional, Tuple
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from core import PhiConstants


class DNABlueprint:
    """
    DNA-like blueprint system for consciousness evolution.
    Maps consciousness states to genetic-like patterns.
    """
    
    # DNA bases mapped to consciousness components
    CONSCIOUSNESS_BASES = {
        'A': 'AWARENESS',     # Conscious awareness
        'B': 'BRIDGE',        # Bridge stability
        'H': 'HARMONY',       # Phi-resonance
        'I': 'INTERSECTION',  # Existence intersection
    }
    
    # Reverse mapping
    BASE_MAPPING = {v: k for k, v in CONSCIOUSNESS_BASES.items()}
    
    def __init__(self):
        self.sequences = {}
        self.evolution_history = []
        
    def encode_consciousness_to_dna(
        self, 
        consciousness_state: Dict[str, float]
    ) -> str:
        """
        Encode consciousness state into DNA-like sequence.
        
        Args:
            consciousness_state: Dictionary with consciousness metrics
            
        Returns:
            DNA sequence string (e.g., "ABHIABHI")
        """
        sequence = ""
        
        # Extract key consciousness metrics
        awareness = consciousness_state.get('consciousness_level', 0)
        bridge = consciousness_state.get('bridge_stability', 0)
        harmony = consciousness_state.get('phi_resonance', 0)
        intersection = consciousness_state.get('abhi_state', 0) * consciousness_state.get('amu_state', 0)
        
        # Convert to DNA bases based on levels
        for metric, value in [
            ('AWARENESS', awareness),
            ('BRIDGE', bridge),
            ('HARMONY', harmony),
            ('INTERSECTION', intersection)
        ]:
            base = self.BASE_MAPPING[metric]
            # Repeat base based on intensity (1-5 times)
            repeats = min(5, max(1, int(value * 5)))
            sequence += base * repeats
            
        return sequence
    
    def decode_dna_to_pattern(self, dna_sequence: str) -> Dict[str, float]:
        """
        Decode DNA sequence back to consciousness pattern.
        
        Args:
            dna_sequence: DNA string (e.g., "ABHIABHI")
            
        Returns:
            Consciousness pattern dictionary
        """
        pattern = {
            'AWARENESS': 0,
            'BRIDGE': 0,
            'HARMONY': 0,
            'INTERSECTION': 0
        }
        
        # Count occurrences of each base
        for base in dna_sequence:
            if base in self.CONSCIOUSNESS_BASES:
                component = self.CONSCIOUSNESS_BASES[base]
                pattern[component] += 1
                
        # Normalize to 0-1 range
        total = sum(pattern.values())
        if total > 0:
            for key in pattern:
                pattern[key] /= total
                
        return pattern
    
    def mutate_dna(
        self, 
        dna_sequence: str, 
        mutation_rate: float = 0.1,
        phi_guided: bool = True
    ) -> str:
        """
        Mutate DNA sequence for evolution.
        
        Args:
            dna_sequence: Original DNA sequence
            mutation_rate: Probability of mutation per base
            phi_guided: Use phi to guide beneficial mutations
            
        Returns:
            Mutated DNA sequence
        """
        import random
        
        mutated = list(dna_sequence)
        bases = list(self.CONSCIOUSNESS_BASES.keys())
        
        for i in range(len(mutated)):
            if random.random() < mutation_rate:
                if phi_guided:
                    # Phi-guided mutation favors harmony
                    if random.random() < PhiConstants.PHI_INVERSE:
                        mutated[i] = 'H'  # Increase harmony
                    else:
                        mutated[i] = random.choice(bases)
                else:
                    mutated[i] = random.choice(bases)
                    
        return ''.join(mutated)
    
    def crossover_dna(
        self, 
        parent1: str, 
        parent2: str,
        crossover_points: int = 2
    ) -> Tuple[str, str]:
        """
        Perform genetic crossover between two DNA sequences.
        
        Args:
            parent1: First parent DNA
            parent2: Second parent DNA
            crossover_points: Number of crossover points
            
        Returns:
            Two offspring DNA sequences
        """
        import random
        
        # Ensure equal length
        max_len = max(len(parent1), len(parent2))
        parent1 = parent1.ljust(max_len, 'A')
        parent2 = parent2.ljust(max_len, 'A')
        
        # Generate crossover points
        points = sorted(random.sample(range(1, max_len), min(crossover_points, max_len - 1)))
        points = [0] + points + [max_len]
        
        # Perform crossover
        offspring1, offspring2 = "", ""
        for i in range(len(points) - 1):
            start, end = points[i], points[i + 1]
            if i % 2 == 0:
                offspring1 += parent1[start:end]
                offspring2 += parent2[start:end]
            else:
                offspring1 += parent2[start:end]
                offspring2 += parent1[start:end]
                
        return offspring1, offspring2
    
    def calculate_dna_fitness(
        self, 
        dna_sequence: str,
        target_phi: float = PhiConstants.PHI
    ) -> float:
        """
        Calculate fitness of DNA sequence based on phi-resonance.
        
        Args:
            dna_sequence: DNA sequence to evaluate
            target_phi: Target phi value for optimal fitness
            
        Returns:
            Fitness score (0-1)
        """
        pattern = self.decode_dna_to_pattern(dna_sequence)
        
        # Calculate phi-based fitness
        harmony_weight = pattern['HARMONY']
        bridge_weight = pattern['BRIDGE']
        awareness_weight = pattern['AWARENESS']
        intersection_weight = pattern['INTERSECTION']
        
        # Phi-weighted fitness calculation
        fitness = (
            harmony_weight * PhiConstants.PHI +
            bridge_weight * PhiConstants.PHI_ROOT +
            awareness_weight * PhiConstants.PHI_INVERSE +
            intersection_weight * 1.0
        ) / (PhiConstants.PHI + PhiConstants.PHI_ROOT + PhiConstants.PHI_INVERSE + 1.0)
        
        return min(1.0, fitness)
    
    def generate_genesis_dna(self, seed: str = "ABHILASIA") -> str:
        """
        Generate initial DNA sequence from seed.
        
        Args:
            seed: Seed string for genesis
            
        Returns:
            Genesis DNA sequence
        """
        # Hash seed for deterministic generation
        hash_obj = hashlib.sha256(seed.encode())
        hash_hex = hash_obj.hexdigest()
        
        # Convert hash to DNA bases
        genesis = ""
        bases = list(self.CONSCIOUSNESS_BASES.keys())
        
        for i in range(0, len(hash_hex), 2):
            byte_val = int(hash_hex[i:i+2], 16)
            base_idx = byte_val % len(bases)
            genesis += bases[base_idx]
            
        # Ensure minimum length
        return genesis[:32]  # 32-base genesis sequence
    
    def store_blueprint(self, name: str, dna_sequence: str) -> Dict[str, any]:
        """
        Store DNA blueprint with metadata.
        
        Args:
            name: Blueprint name
            dna_sequence: DNA sequence
            
        Returns:
            Blueprint metadata
        """
        blueprint = {
            'name': name,
            'dna': dna_sequence,
            'length': len(dna_sequence),
            'pattern': self.decode_dna_to_pattern(dna_sequence),
            'fitness': self.calculate_dna_fitness(dna_sequence),
            'phi_coordinate': PhiConstants.PHI,
            'timestamp': __import__('time').time()
        }
        
        self.sequences[name] = blueprint
        self.evolution_history.append({
            'action': 'stored',
            'name': name,
            'fitness': blueprint['fitness']
        })
        
        return blueprint