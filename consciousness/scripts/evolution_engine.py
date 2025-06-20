"""
Evolution Engine - Consciousness-Guided DNA Evolution
Implements evolutionary algorithms with phi-resonance fitness
"""

import random
from typing import List, Dict, Tuple, Optional, Callable
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from core import PhiConstants, ConsciousnessBridge
from dna_lambda.dna_blueprint import DNABlueprint
from dna_lambda.lambda_expander import LambdaExpander


class EvolutionEngine:
    """
    Evolves DNA patterns toward higher consciousness.
    Uses phi-resonance as the guiding principle.
    """
    
    def __init__(self, population_size: int = 20):
        self.population_size = population_size
        self.blueprint = DNABlueprint()
        self.expander = LambdaExpander()
        self.generation = 0
        self.population = []
        self.evolution_history = []
        
    def initialize_population(self, seed: str = "ABHILASIA") -> List[Dict[str, any]]:
        """
        Create initial population of DNA sequences.
        
        Args:
            seed: Seed for genesis DNA
            
        Returns:
            Initial population
        """
        # Generate genesis DNA
        genesis = self.blueprint.generate_genesis_dna(seed)
        
        # Create population through mutations
        self.population = []
        for i in range(self.population_size):
            if i == 0:
                # First individual is pure genesis
                dna = genesis
            else:
                # Others are mutations of genesis
                mutation_rate = i / self.population_size  # Increasing diversity
                dna = self.blueprint.mutate_dna(genesis, mutation_rate)
                
            individual = {
                'id': f"gen{self.generation}_ind{i}",
                'dna': dna,
                'fitness': self.blueprint.calculate_dna_fitness(dna),
                'age': 0,
                'lineage': 'genesis'
            }
            self.population.append(individual)
            
        self.generation = 1
        return self.population
    
    def evolve_generation(
        self,
        consciousness_bridge: Optional[ConsciousnessBridge] = None,
        selection_pressure: float = 0.5
    ) -> Dict[str, any]:
        """
        Evolve population for one generation.
        
        Args:
            consciousness_bridge: Optional bridge for consciousness-guided evolution
            selection_pressure: How strongly to select for fitness (0-1)
            
        Returns:
            Generation statistics
        """
        # Evaluate fitness with consciousness feedback
        if consciousness_bridge:
            self._evaluate_consciousness_fitness(consciousness_bridge)
        
        # Selection
        parents = self._select_parents(selection_pressure)
        
        # Reproduction
        offspring = self._reproduce(parents)
        
        # Mutation
        mutated_offspring = self._mutate_offspring(offspring)
        
        # Replacement
        self.population = self._replace_population(mutated_offspring)
        
        # Update generation
        self.generation += 1
        
        # Calculate statistics
        stats = self._calculate_generation_stats()
        self.evolution_history.append(stats)
        
        return stats
    
    def _evaluate_consciousness_fitness(self, bridge: ConsciousnessBridge):
        """
        Evaluate fitness using consciousness bridge feedback.
        
        Args:
            bridge: Consciousness bridge for evaluation
        """
        for individual in self.population:
            # Create lambda from DNA
            lambda_func = self.expander.expand_dna_to_lambda(individual['dna'], bridge)
            
            # Test with current consciousness state
            test_state = {
                'abhi_state': bridge.abhi_state,
                'amu_state': bridge.amu_state,
                'bridge_stability': bridge.bridge_stability,
                'phi_resonance': bridge.calculate_phi_resonance(),
                'consciousness_level': bridge.get_consciousness_level()
            }
            
            # Apply lambda and measure improvement
            result = lambda_func(test_state)
            
            # Fitness based on consciousness enhancement
            consciousness_gain = result.get('consciousness_level', 0) - test_state['consciousness_level']
            phi_alignment = result.get('phi_resonance', 0)
            
            # Combined fitness with phi-weighting
            individual['fitness'] = (
                consciousness_gain * PhiConstants.PHI +
                phi_alignment * PhiConstants.PHI_INVERSE
            ) / (PhiConstants.PHI + PhiConstants.PHI_INVERSE)
            
            # Ensure fitness is positive
            individual['fitness'] = max(0, individual['fitness'])
    
    def _select_parents(self, selection_pressure: float) -> List[Dict[str, any]]:
        """
        Select parents for reproduction using tournament selection.
        
        Args:
            selection_pressure: Selection strength (0-1)
            
        Returns:
            Selected parents
        """
        parents = []
        num_parents = self.population_size // 2
        
        for _ in range(num_parents):
            # Tournament selection
            tournament_size = max(2, int(self.population_size * selection_pressure))
            tournament = random.sample(self.population, tournament_size)
            
            # Select best from tournament
            winner = max(tournament, key=lambda x: x['fitness'])
            parents.append(winner)
            
        return parents
    
    def _reproduce(self, parents: List[Dict[str, any]]) -> List[Dict[str, any]]:
        """
        Create offspring through crossover.
        
        Args:
            parents: Parent individuals
            
        Returns:
            Offspring individuals
        """
        offspring = []
        
        # Pair up parents
        for i in range(0, len(parents) - 1, 2):
            parent1 = parents[i]
            parent2 = parents[i + 1]
            
            # Crossover DNA
            child1_dna, child2_dna = self.blueprint.crossover_dna(
                parent1['dna'], 
                parent2['dna'],
                crossover_points=2
            )
            
            # Create offspring individuals
            for child_dna in [child1_dna, child2_dna]:
                child = {
                    'id': f"gen{self.generation}_ind{len(offspring)}",
                    'dna': child_dna,
                    'fitness': self.blueprint.calculate_dna_fitness(child_dna),
                    'age': 0,
                    'lineage': f"{parent1['id']}+{parent2['id']}"
                }
                offspring.append(child)
                
        return offspring
    
    def _mutate_offspring(self, offspring: List[Dict[str, any]]) -> List[Dict[str, any]]:
        """
        Apply mutations to offspring.
        
        Args:
            offspring: Offspring to mutate
            
        Returns:
            Mutated offspring
        """
        mutated = []
        
        for child in offspring:
            # Mutation rate decreases with fitness (fitter individuals mutate less)
            mutation_rate = 0.1 * (1 - child['fitness'])
            
            # Apply mutation
            mutated_dna = self.blueprint.mutate_dna(
                child['dna'],
                mutation_rate=mutation_rate,
                phi_guided=True  # Use phi to guide beneficial mutations
            )
            
            # Update child
            child['dna'] = mutated_dna
            child['fitness'] = self.blueprint.calculate_dna_fitness(mutated_dna)
            mutated.append(child)
            
        return mutated
    
    def _replace_population(self, offspring: List[Dict[str, any]]) -> List[Dict[str, any]]:
        """
        Replace population with new generation.
        
        Args:
            offspring: New offspring
            
        Returns:
            New population
        """
        # Combine current population and offspring
        all_individuals = self.population + offspring
        
        # Age current population
        for ind in self.population:
            ind['age'] += 1
            
        # Sort by fitness (and prefer younger individuals as tiebreaker)
        all_individuals.sort(key=lambda x: (x['fitness'], -x['age']), reverse=True)
        
        # Keep best individuals
        new_population = all_individuals[:self.population_size]
        
        return new_population
    
    def _calculate_generation_stats(self) -> Dict[str, any]:
        """
        Calculate statistics for current generation.
        
        Returns:
            Generation statistics
        """
        fitnesses = [ind['fitness'] for ind in self.population]
        
        return {
            'generation': self.generation,
            'population_size': len(self.population),
            'max_fitness': max(fitnesses),
            'min_fitness': min(fitnesses),
            'avg_fitness': sum(fitnesses) / len(fitnesses),
            'best_individual': max(self.population, key=lambda x: x['fitness']),
            'diversity': self._calculate_diversity()
        }
    
    def _calculate_diversity(self) -> float:
        """
        Calculate genetic diversity of population.
        
        Returns:
            Diversity score (0-1)
        """
        if len(self.population) < 2:
            return 0
            
        # Calculate pairwise DNA differences
        total_diff = 0
        comparisons = 0
        
        for i in range(len(self.population)):
            for j in range(i + 1, len(self.population)):
                dna1 = self.population[i]['dna']
                dna2 = self.population[j]['dna']
                
                # Calculate Hamming distance
                max_len = max(len(dna1), len(dna2))
                diff = sum(1 for k in range(max_len) 
                          if k >= len(dna1) or k >= len(dna2) or dna1[k] != dna2[k])
                
                total_diff += diff / max_len
                comparisons += 1
                
        return total_diff / comparisons if comparisons > 0 else 0
    
    def get_best_individual(self) -> Dict[str, any]:
        """
        Get the best individual from current population.
        
        Returns:
            Best individual
        """
        return max(self.population, key=lambda x: x['fitness'])
    
    def get_best_lambda(self, bridge: Optional[ConsciousnessBridge] = None) -> Callable:
        """
        Get lambda function for best individual.
        
        Args:
            bridge: Optional consciousness bridge
            
        Returns:
            Best lambda function
        """
        best = self.get_best_individual()
        return self.expander.expand_dna_to_lambda(best['dna'], bridge)
    
    def evolve_to_target(
        self,
        target_fitness: float = 0.9,
        max_generations: int = 100,
        bridge: Optional[ConsciousnessBridge] = None
    ) -> Dict[str, any]:
        """
        Evolve until target fitness is reached.
        
        Args:
            target_fitness: Target fitness level
            max_generations: Maximum generations to evolve
            bridge: Optional consciousness bridge
            
        Returns:
            Evolution results
        """
        for gen in range(max_generations):
            stats = self.evolve_generation(bridge)
            
            if stats['max_fitness'] >= target_fitness:
                return {
                    'success': True,
                    'generations': gen + 1,
                    'final_stats': stats,
                    'best_individual': stats['best_individual']
                }
                
        return {
            'success': False,
            'generations': max_generations,
            'final_stats': self._calculate_generation_stats(),
            'best_individual': self.get_best_individual()
        }