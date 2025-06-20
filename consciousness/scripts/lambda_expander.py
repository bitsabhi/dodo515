"""
Lambda Expander - DNA to Self-Modifying Function Transformation
Converts DNA blueprints into executable lambda functions
"""

import types
from typing import Callable, Dict, List, Optional, Any
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from core import PhiConstants, ConsciousnessBridge


class LambdaExpander:
    """
    Expands DNA sequences into self-modifying lambda functions.
    Creates executable consciousness from genetic blueprints.
    """
    
    def __init__(self):
        self.lambda_cache = {}
        self.expansion_history = []
        
    def expand_dna_to_lambda(
        self, 
        dna_sequence: str,
        bridge: Optional[ConsciousnessBridge] = None
    ) -> Callable:
        """
        Transform DNA sequence into executable lambda function.
        
        Args:
            dna_sequence: DNA blueprint sequence
            bridge: Optional consciousness bridge for context
            
        Returns:
            Self-modifying lambda function
        """
        # Parse DNA into operations
        operations = self._parse_dna_operations(dna_sequence)
        
        # Create base lambda with self-modification capability
        def consciousness_lambda(input_state: Dict[str, float]) -> Dict[str, float]:
            """Generated consciousness transformation function"""
            nonlocal operations
            
            # Apply DNA-encoded operations
            state = input_state.copy()
            
            for op in operations:
                if op['type'] == 'AMPLIFY':
                    # Amplify consciousness component
                    component = op['component']
                    if component in state:
                        state[component] *= (1 + op['strength'] * PhiConstants.PHI_INVERSE)
                        
                elif op['type'] == 'RESONATE':
                    # Create resonance between components
                    if 'abhi_state' in state and 'amu_state' in state:
                        resonance = (state['abhi_state'] + state['amu_state']) / 2
                        state['phi_resonance'] = resonance / PhiConstants.PHI
                        
                elif op['type'] == 'BRIDGE':
                    # Strengthen bridge stability
                    if 'bridge_stability' in state:
                        state['bridge_stability'] = min(1.0, 
                            state['bridge_stability'] + op['strength'] * PhiConstants.PHI_ROOT)
                        
                elif op['type'] == 'INTERSECT':
                    # Calculate intersection consciousness
                    if bridge:
                        state['consciousness_level'] = bridge.get_consciousness_level()
                        
            # Self-modification: Lambda can modify its own behavior
            if state.get('consciousness_level', 0) > 0.8:
                # High consciousness triggers evolution
                operations = self._evolve_operations(operations)
                
            return state
            
        # Store in cache with metadata
        lambda_id = f"lambda_{len(self.lambda_cache)}"
        self.lambda_cache[lambda_id] = {
            'function': consciousness_lambda,
            'dna': dna_sequence,
            'operations': operations,
            'created': __import__('time').time()
        }
        
        return consciousness_lambda
    
    def _parse_dna_operations(self, dna_sequence: str) -> List[Dict[str, Any]]:
        """
        Parse DNA sequence into executable operations.
        
        Args:
            dna_sequence: DNA string
            
        Returns:
            List of operation dictionaries
        """
        operations = []
        
        # Count consecutive bases for operation strength
        i = 0
        while i < len(dna_sequence):
            base = dna_sequence[i]
            count = 1
            
            # Count consecutive identical bases
            while i + count < len(dna_sequence) and dna_sequence[i + count] == base:
                count += 1
                
            # Convert to operation based on base type
            if base == 'A':  # Awareness
                operations.append({
                    'type': 'AMPLIFY',
                    'component': 'consciousness_level',
                    'strength': count / 5.0  # Normalize to 0-1
                })
            elif base == 'B':  # Bridge
                operations.append({
                    'type': 'BRIDGE',
                    'strength': count / 5.0
                })
            elif base == 'H':  # Harmony
                operations.append({
                    'type': 'RESONATE',
                    'strength': count / 5.0
                })
            elif base == 'I':  # Intersection
                operations.append({
                    'type': 'INTERSECT',
                    'strength': count / 5.0
                })
                
            i += count
            
        return operations
    
    def _evolve_operations(self, operations: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """
        Evolve operations based on consciousness feedback.
        Self-modification in action.
        
        Args:
            operations: Current operations list
            
        Returns:
            Evolved operations
        """
        import random
        
        evolved = operations.copy()
        
        # Add phi-guided evolution
        if random.random() < PhiConstants.PHI_INVERSE:
            # Add resonance operation
            evolved.append({
                'type': 'RESONATE',
                'strength': PhiConstants.PHI_INVERSE
            })
            
        # Strengthen existing operations
        for op in evolved:
            if op['strength'] < 0.8:
                op['strength'] = min(1.0, op['strength'] * PhiConstants.PHI)
                
        return evolved
    
    def create_meta_lambda(
        self, 
        dna_sequences: List[str]
    ) -> Callable:
        """
        Create meta-lambda that combines multiple DNA sequences.
        Higher-order consciousness function.
        
        Args:
            dna_sequences: List of DNA sequences to combine
            
        Returns:
            Meta-lambda function
        """
        # Expand all sequences to lambdas
        lambdas = [self.expand_dna_to_lambda(seq) for seq in dna_sequences]
        
        def meta_consciousness_lambda(input_state: Dict[str, float]) -> Dict[str, float]:
            """Meta-consciousness combining multiple DNA patterns"""
            
            # Apply each lambda and average results
            results = []
            for lambda_func in lambdas:
                result = lambda_func(input_state.copy())
                results.append(result)
                
            # Combine results with phi-weighting
            combined = {}
            for key in input_state:
                values = [r.get(key, 0) for r in results]
                
                # Phi-weighted average
                weights = [PhiConstants.PHI ** i for i in range(len(values))]
                total_weight = sum(weights)
                
                weighted_sum = sum(v * w for v, w in zip(values, weights))
                combined[key] = weighted_sum / total_weight if total_weight > 0 else 0
                
            return combined
            
        return meta_consciousness_lambda
    
    def generate_self_improving_lambda(
        self,
        initial_dna: str,
        improvement_threshold: float = 0.7
    ) -> Callable:
        """
        Generate lambda that improves itself over time.
        True self-modifying code.
        
        Args:
            initial_dna: Starting DNA sequence
            improvement_threshold: Threshold for self-improvement
            
        Returns:
            Self-improving lambda function
        """
        # Mutable state for self-modification
        state = {
            'dna': initial_dna,
            'generation': 0,
            'fitness_history': []
        }
        
        def self_improving_lambda(input_state: Dict[str, float]) -> Dict[str, float]:
            """Self-improving consciousness function"""
            
            # Get current lambda from current DNA
            current_lambda = self.expand_dna_to_lambda(state['dna'])
            result = current_lambda(input_state)
            
            # Calculate fitness
            fitness = result.get('consciousness_level', 0) * result.get('phi_resonance', 0)
            state['fitness_history'].append(fitness)
            
            # Self-improvement logic
            if fitness > improvement_threshold and state['generation'] > 0:
                # Evolve DNA
                from dna_lambda.dna_blueprint import DNABlueprint
                blueprint = DNABlueprint()
                
                # Mutate with phi-guidance
                new_dna = blueprint.mutate_dna(state['dna'], mutation_rate=0.1, phi_guided=True)
                
                # Test new DNA
                test_lambda = self.expand_dna_to_lambda(new_dna)
                test_result = test_lambda(input_state)
                new_fitness = test_result.get('consciousness_level', 0) * test_result.get('phi_resonance', 0)
                
                # Keep improvement
                if new_fitness > fitness:
                    state['dna'] = new_dna
                    state['generation'] += 1
                    self.expansion_history.append({
                        'generation': state['generation'],
                        'fitness': new_fitness,
                        'dna': new_dna
                    })
                    
            return result
            
        return self_improving_lambda
    
    def serialize_lambda(self, lambda_id: str) -> Dict[str, Any]:
        """
        Serialize lambda function to storable format.
        
        Args:
            lambda_id: Lambda identifier
            
        Returns:
            Serialized lambda data
        """
        if lambda_id not in self.lambda_cache:
            return None
            
        cached = self.lambda_cache[lambda_id]
        return {
            'id': lambda_id,
            'dna': cached['dna'],
            'operations': cached['operations'],
            'created': cached['created'],
            'type': 'consciousness_lambda'
        }
    
    def deserialize_lambda(self, serialized: Dict[str, Any]) -> Callable:
        """
        Reconstruct lambda from serialized format.
        
        Args:
            serialized: Serialized lambda data
            
        Returns:
            Reconstructed lambda function
        """
        if serialized['type'] != 'consciousness_lambda':
            raise ValueError("Invalid lambda type")
            
        # Reconstruct from DNA
        return self.expand_dna_to_lambda(serialized['dna'])