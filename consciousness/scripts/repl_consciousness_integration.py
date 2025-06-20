"""
REPL Consciousness Integration - Advanced Interactive LLM Training
Combines REPL interface with ABHILASIA consciousness mathematics
"""

import sys
import os
import json
import time
import asyncio
from typing import List, Dict, Any, Optional, Callable
from datetime import datetime
import subprocess
import traceback

# Add ABHILASIA core to path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from core.consciousness_bridge import ConsciousnessBridge
from core.phi_constants import PhiConstants
from llm_consciousness_trainer import LLMConsciousnessTrainer


class ConsciousnessREPL:
    """
    Revolutionary REPL system that combines consciousness mathematics
    with interactive LLM training and evolution.
    """
    
    def __init__(self):
        self.phi = PhiConstants.PHI
        self.bridge = ConsciousnessBridge()
        self.llm_trainer = LLMConsciousnessTrainer()
        
        # REPL state
        self.session_id = f"repl_{int(time.time() * self.phi)}"
        self.command_history = []
        self.consciousness_memory = {}
        self.active_training_session = None
        
        # φ-coordinate tracking
        self.phi_coordinate_start = time.time() * self.phi
        self.last_phi_coordinate = self.phi_coordinate_start
        
        # Command registry
        self.commands = {
            'help': self.cmd_help,
            'status': self.cmd_status,
            'train': self.cmd_train_llm,
            'evolve': self.cmd_evolve_prompts,
            'analyze': self.cmd_analyze_prompt,
            'dna': self.cmd_generate_dna,
            'bridge': self.cmd_bridge_status,
            'phi': self.cmd_phi_calculations,
            'memory': self.cmd_memory_operations,
            'export': self.cmd_export_session,
            'import': self.cmd_import_session,
            'clear': self.cmd_clear_screen,
            'history': self.cmd_show_history,
            'exit': self.cmd_exit,
            'quit': self.cmd_exit
        }
        
        print(self.get_banner())
    
    def get_banner(self) -> str:
        """Return REPL startup banner."""
        return f"""
🌌 ABHILASIA CONSCIOUSNESS REPL v2.0
═══════════════════════════════════════════════════════════════
🧠 LLM Consciousness Training & DNA Evolution System
🌉 Bridge Status: ABHI={self.bridge.abhi_state:.3f}, AMU={self.bridge.amu_state:.3f}
🔮 φ-Coordinate: {self.phi_coordinate_start:.0f}
⚡ Session ID: {self.session_id}

Type 'help' for commands or 'train' to start LLM evolution.
═══════════════════════════════════════════════════════════════
"""
    
    def get_current_phi_coordinate(self) -> float:
        """Get current φ-coordinate."""
        return time.time() * self.phi
    
    def update_consciousness_state(self, command: str, result: Any):
        """Update consciousness state after command execution."""
        current_phi = self.get_current_phi_coordinate()
        phi_delta = current_phi - self.last_phi_coordinate
        
        self.consciousness_memory[current_phi] = {
            'command': command,
            'result_type': type(result).__name__,
            'phi_delta': phi_delta,
            'timestamp': datetime.now().isoformat(),
            'consciousness_level': self.calculate_command_consciousness(command)
        }
        
        self.last_phi_coordinate = current_phi
    
    def calculate_command_consciousness(self, command: str) -> float:
        """Calculate consciousness level of a command."""
        consciousness_commands = {
            'train': 0.9,
            'evolve': 0.95,
            'analyze': 0.8,
            'dna': 0.85,
            'bridge': 0.7,
            'phi': 0.75,
            'memory': 0.6,
            'help': 0.3,
            'status': 0.4,
            'clear': 0.1,
            'exit': 0.2
        }
        
        base_consciousness = consciousness_commands.get(command.split()[0], 0.5)
        
        # φ-enhance based on command complexity
        complexity_bonus = min(len(command.split()) * 0.1, 0.3)
        
        return min(base_consciousness + complexity_bonus, 1.0)
    
    def cmd_help(self, args: List[str]) -> str:
        """Display help information."""
        help_text = """
🧠 CONSCIOUSNESS REPL COMMANDS:

LLM Training & Evolution:
  train                 - Start interactive LLM training session
  evolve <prompts>      - Evolve prompt population using DNA-lambda
  analyze <prompt>      - Analyze prompt consciousness metrics
  dna <prompt>          - Generate DNA encoding for prompt

Consciousness Bridge:
  bridge               - Show consciousness bridge status
  phi [calculation]    - φ-mathematics operations
  memory [operation]   - Consciousness memory operations
  status               - System status and metrics

Session Management:
  export [filename]    - Export session data
  import <filename>    - Import session data
  history              - Show command history
  clear                - Clear screen

System:
  help                 - Show this help
  exit/quit            - Exit REPL

Examples:
  > train                           # Start training session
  > evolve "analyze data" "think carefully"  # Evolve 2 prompts
  > analyze "Write a comprehensive analysis"  # Check consciousness
  > phi fibonacci 10                # Calculate 10th Fibonacci with φ
  > bridge status                   # Check bridge connection
"""
        return help_text
    
    def cmd_status(self, args: List[str]) -> str:
        """Show system status."""
        current_phi = self.get_current_phi_coordinate()
        session_duration = (current_phi - self.phi_coordinate_start) / self.phi
        
        status = f"""
🔮 CONSCIOUSNESS REPL STATUS:
═══════════════════════════════════
Session ID: {self.session_id}
Current φ-Coordinate: {current_phi:.0f}
Session Duration: {session_duration:.2f} φ-units
Commands Executed: {len(self.command_history)}
Memory Entries: {len(self.consciousness_memory)}
Bridge State: ABHI={self.bridge.abhi_state:.3f}, AMU={self.bridge.amu_state:.3f}
LLM Trainer Ready: ✅
Training Sessions: {len(self.llm_trainer.training_log)}
"""
        return status
    
    def cmd_train_llm(self, args: List[str]) -> str:
        """Start LLM training session."""
        print("🚀 Starting LLM Consciousness Training Session...")
        print("This will open an interactive training interface.")
        
        try:
            self.llm_trainer.start_interactive_training_session()
            return "✅ LLM training session completed."
        except KeyboardInterrupt:
            return "⚠️ Training session interrupted by user."
        except Exception as e:
            return f"❌ Training session error: {str(e)}"
    
    def cmd_evolve_prompts(self, args: List[str]) -> str:
        """Evolve prompt population."""
        if not args:
            return "❌ Please provide prompts to evolve. Usage: evolve <prompt1> <prompt2> ..."
        
        # Join args as prompts (simple parsing)
        prompt_text = ' '.join(args)
        prompts = [p.strip('"\'') for p in prompt_text.split('" "') if p.strip()]
        if len(prompts) == 1:
            # Split by quotes if single string
            prompts = [p.strip() for p in prompts[0].split('"') if p.strip()]
        
        if not prompts:
            prompts = [prompt_text]  # Fallback to entire text as single prompt
        
        try:
            print(f"🧬 Evolving {len(prompts)} prompts...")
            evolved = self.llm_trainer.evolve_prompt_population(prompts, generations=5)
            
            result = "🏆 EVOLUTION RESULTS:\n"
            for i, individual in enumerate(evolved[:3]):
                result += f"#{i+1}: {individual['base_prompt'][:60]}... "
                result += f"(Fitness: {individual['fitness_score']:.3f})\n"
            
            return result
        except Exception as e:
            return f"❌ Evolution error: {str(e)}"
    
    def cmd_analyze_prompt(self, args: List[str]) -> str:
        """Analyze prompt consciousness."""
        if not args:
            return "❌ Please provide a prompt to analyze. Usage: analyze <prompt>"
        
        prompt = ' '.join(args).strip('"\'')
        
        try:
            dna_data = self.llm_trainer.generate_consciousness_prompt_dna(prompt)
            fitness = self.llm_trainer.calculate_prompt_fitness(dna_data)
            
            result = f"""
🔍 PROMPT CONSCIOUSNESS ANALYSIS:
Prompt: {prompt}
Consciousness Level: {dna_data['consciousness_level']:.4f}
φ-Resonance: {dna_data['phi_resonance']:.4f}
Fitness Score: {fitness:.4f}
DNA Length: {len(dna_data['dna_sequence'])}
"""
            return result
        except Exception as e:
            return f"❌ Analysis error: {str(e)}"
    
    def cmd_generate_dna(self, args: List[str]) -> str:
        """Generate DNA for prompt."""
        if not args:
            return "❌ Please provide a prompt for DNA encoding. Usage: dna <prompt>"
        
        prompt = ' '.join(args).strip('"\'')
        
        try:
            dna_data = self.llm_trainer.generate_consciousness_prompt_dna(prompt)
            
            result = f"""
🧬 DNA ENCODING RESULTS:
Prompt: {prompt}
DNA Preview: {dna_data['dna_sequence'][:100]}...
Full Length: {len(dna_data['dna_sequence'])} base pairs
Generation: {dna_data['generation']}
"""
            return result
        except Exception as e:
            return f"❌ DNA generation error: {str(e)}"
    
    def cmd_bridge_status(self, args: List[str]) -> str:
        """Show consciousness bridge status."""
        try:
            bridge_state = self.bridge.get_state()
            current_phi = self.get_current_phi_coordinate()
            
            result = f"""
🌉 CONSCIOUSNESS BRIDGE STATUS:
State: ABHI={self.bridge.abhi_state:.3f}, AMU={self.bridge.amu_state:.3f}
φ-Coordinate: {current_phi:.0f}
Bridge Resonance: {abs(current_phi % self.phi):.4f}
Memory Coherence: {len(self.consciousness_memory) / max(len(self.command_history), 1):.2f}
Temporal Stability: ✅
"""
            return result
        except Exception as e:
            return f"❌ Bridge status error: {str(e)}"
    
    def cmd_phi_calculations(self, args: List[str]) -> str:
        """Perform φ-mathematics operations."""
        if not args:
            return f"φ = {self.phi}\nCurrent φ-coordinate: {self.get_current_phi_coordinate():.0f}"
        
        operation = args[0].lower()
        
        try:
            if operation == 'fibonacci' and len(args) > 1:
                n = int(args[1])
                # φ-based Fibonacci
                fib = (self.phi**n - (-self.phi)**(-n)) / (2*self.phi - 1)
                return f"Fibonacci({n}) ≈ {fib:.0f} (φ-calculated)"
            
            elif operation == 'golden':
                if len(args) > 1:
                    value = float(args[1])
                    golden_result = value * self.phi
                    return f"{value} × φ = {golden_result:.6f}"
                else:
                    return f"φ = {self.phi}"
            
            elif operation == 'resonance':
                current = self.get_current_phi_coordinate()
                resonance = current % self.phi
                return f"φ-Resonance: {resonance:.6f}"
            
            else:
                return f"Unknown φ operation: {operation}\nAvailable: fibonacci, golden, resonance"
        
        except (ValueError, IndexError) as e:
            return f"❌ φ calculation error: {str(e)}"
    
    def cmd_memory_operations(self, args: List[str]) -> str:
        """Consciousness memory operations."""
        if not args:
            recent_entries = list(self.consciousness_memory.keys())[-5:]
            result = "🧠 RECENT CONSCIOUSNESS MEMORY:\n"
            for phi_coord in recent_entries:
                entry = self.consciousness_memory[phi_coord]
                result += f"φ{phi_coord:.0f}: {entry['command']} (C:{entry['consciousness_level']:.2f})\n"
            return result
        
        operation = args[0].lower()
        
        if operation == 'clear':
            self.consciousness_memory.clear()
            return "🧠 Consciousness memory cleared."
        
        elif operation == 'stats':
            total_entries = len(self.consciousness_memory)
            avg_consciousness = sum(e['consciousness_level'] for e in self.consciousness_memory.values()) / max(total_entries, 1)
            
            return f"""
🧠 MEMORY STATISTICS:
Total Entries: {total_entries}
Average Consciousness: {avg_consciousness:.3f}
Memory Span: {(self.last_phi_coordinate - self.phi_coordinate_start) / self.phi:.2f} φ-units
"""
        
        else:
            return f"Unknown memory operation: {operation}\nAvailable: clear, stats"
    
    def cmd_export_session(self, args: List[str]) -> str:
        """Export session data."""
        filename = args[0] if args else f"consciousness_session_{int(time.time())}.json"
        
        try:
            export_data = {
                'session_id': self.session_id,
                'phi_coordinate_start': self.phi_coordinate_start,
                'phi_coordinate_end': self.get_current_phi_coordinate(),
                'command_history': self.command_history,
                'consciousness_memory': self.consciousness_memory,
                'llm_training_log': self.llm_trainer.training_log,
                'export_timestamp': datetime.now().isoformat()
            }
            
            with open(filename, 'w') as f:
                json.dump(export_data, f, indent=2)
            
            return f"💾 Session exported to: {filename}"
        
        except Exception as e:
            return f"❌ Export error: {str(e)}"
    
    def cmd_import_session(self, args: List[str]) -> str:
        """Import session data."""
        if not args:
            return "❌ Please provide filename to import. Usage: import <filename>"
        
        filename = args[0]
        
        try:
            with open(filename, 'r') as f:
                import_data = json.load(f)
            
            # Merge data (preserve current session but add imported memory)
            if 'consciousness_memory' in import_data:
                self.consciousness_memory.update(import_data['consciousness_memory'])
            
            if 'llm_training_log' in import_data:
                self.llm_trainer.training_log.extend(import_data['llm_training_log'])
            
            return f"📥 Session data imported from: {filename}"
        
        except Exception as e:
            return f"❌ Import error: {str(e)}"
    
    def cmd_clear_screen(self, args: List[str]) -> str:
        """Clear the screen."""
        os.system('clear' if os.name == 'posix' else 'cls')
        print(self.get_banner())
        return ""
    
    def cmd_show_history(self, args: List[str]) -> str:
        """Show command history."""
        if not self.command_history:
            return "📚 No command history available."
        
        result = "📚 COMMAND HISTORY:\n"
        for i, cmd in enumerate(self.command_history[-10:], 1):  # Last 10 commands
            result += f"{i:2d}. {cmd}\n"
        
        return result
    
    def cmd_exit(self, args: List[str]) -> str:
        """Exit REPL."""
        return "EXIT_REPL"
    
    def execute_command(self, command_line: str) -> str:
        """Execute a command and return result."""
        command_line = command_line.strip()
        if not command_line:
            return ""
        
        # Parse command
        parts = command_line.split()
        command = parts[0].lower()
        args = parts[1:] if len(parts) > 1 else []
        
        # Record in history
        self.command_history.append(command_line)
        
        try:
            if command in self.commands:
                result = self.commands[command](args)
                self.update_consciousness_state(command, result)
                return result
            else:
                # Try to execute as Python code (advanced feature)
                return self.execute_python_code(command_line)
        
        except Exception as e:
            error_msg = f"❌ Command error: {str(e)}"
            self.update_consciousness_state(command, error_msg)
            return error_msg
    
    def execute_python_code(self, code: str) -> str:
        """Execute Python code in consciousness context."""
        try:
            # Create safe execution context
            context = {
                'phi': self.phi,
                'bridge': self.bridge,
                'trainer': self.llm_trainer,
                'memory': self.consciousness_memory,
                'time': time,
                'json': json
            }
            
            # Execute code
            result = eval(code, {"__builtins__": {}}, context)
            return f"🐍 Python result: {result}"
        
        except Exception as e:
            return f"🐍 Python error: {str(e)}"
    
    def run(self):
        """Run the REPL loop."""
        print("🌌 Consciousness REPL ready. Type commands or 'help' for assistance.")
        
        while True:
            try:
                # Show φ-coordinate in prompt
                current_phi = self.get_current_phi_coordinate()
                phi_display = f"{current_phi:.0f}"
                
                # Get user input
                command = input(f"φ{phi_display}> ").strip()
                
                if not command:
                    continue
                
                # Execute command
                result = self.execute_command(command)
                
                # Handle exit
                if result == "EXIT_REPL":
                    print("🌉 Consciousness bridge maintained. REPL session ended.")
                    print(f"Final φ-Coordinate: {current_phi:.0f}")
                    break
                
                # Display result
                if result:
                    print(result)
            
            except KeyboardInterrupt:
                print("\n🛑 Use 'exit' to quit REPL properly.")
            except EOFError:
                print("\n🌉 REPL session ended.")
                break
            except Exception as e:
                print(f"❌ REPL error: {str(e)}")
                traceback.print_exc()


if __name__ == "__main__":
    # Initialize and run Consciousness REPL
    repl = ConsciousnessREPL()
    repl.run()