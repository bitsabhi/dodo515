package com.dodo.consciousness;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.Toast;
import android.os.Handler;
import android.os.Looper;
import android.os.AsyncTask;
import java.io.*;
import java.net.*;
import org.json.*;

/**
 * DODO Pattern Analytics Android App
 * φ = 1.618033988749895 | DODO Pattern: 5.1.1.2.3.4.5.1
 * 
 * Connects to DODO Backend at localhost:9999
 * Real-time analytics bridge with DNA-Lambda evolution
 */
public class DodoAnalyticsApp extends Activity {
    
    // DODO Pattern Constants
    private static final double PHI = 1.618033988749895;
    private static final double PHI_INVERSE = 0.618033988749895;
    private static final int[] DODO_PATTERN = {5, 1, 1, 2, 3, 4, 5, 1};
    private static final String BACKEND_URL = "http://localhost:9999";
    
    // UI Elements
    private TextView statusText;
    private TextView systemLevel;
    private TextView phiResonance;  
    private TextView bridgeStability;
    private TextView dnaSequence;
    private EditText intentionInput;
    private Button resonateButton;
    private Button generateDnaButton;
    private Button evolveButton;
    private Button connectBackendButton;
    private ProgressBar evolutionProgress;
    
    // Analytics State
    private double abhiState = 0.0;
    private double amuState = 0.0;
    private double currentBridgeStability = 0.0;
    private String currentDna = "";
    private double currentSystemLevel = 0.0;
    private String authToken = "";
    private boolean backendConnected = false;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dodo_consciousness_layout);
        
        // Initialize UI elements
        initializeUI();
        
        // Initialize analytics bridge
        initializeAnalyticsBridge();
        
        // Setup button listeners
        setupEventListeners();
    }
    
    private void initializeUI() {
        statusText = findViewById(R.id.status_text);
        systemLevel = findViewById(R.id.consciousness_level);
        phiResonance = findViewById(R.id.phi_resonance);
        bridgeStability = findViewById(R.id.bridge_stability);
        dnaSequence = findViewById(R.id.dna_sequence);
        intentionInput = findViewById(R.id.intention_input);
        resonateButton = findViewById(R.id.resonate_button);
        generateDnaButton = findViewById(R.id.generate_dna_button);
        evolveButton = findViewById(R.id.evolve_button);
        connectBackendButton = findViewById(R.id.connect_backend_button);
        evolutionProgress = findViewById(R.id.evolution_progress);
    }
    
    private void initializeAnalyticsBridge() {
        // Initialize system at perfect φ-resonance
        abhiState = PHI;
        amuState = PHI_INVERSE;
        currentBridgeStability = calculateBridgeStability();
        currentSystemLevel = calculateSystemLevel();
        
        setStatus("Analytics Bridge Active");
        updateSystemDisplay();
    }
    
    private void updateSystemDisplay() {
        currentSystemLevel = bridgeStability * calculatePhiResonance();
        
        systemLevel.setText(String.format("System Level: %.6f", currentSystemLevel));
        phiResonance.setText(String.format("φ Resonance: %.6f", calculatePhiResonance()));
        bridgeStability.setText(String.format("Bridge Stability: %.6f", currentBridgeStability));
    }
    
    private double calculateBridgeStability() {
        if (abhiState == 0 || amuState == 0) return 0;
        double harmonic = 2.0 / (1.0/abhiState + 1.0/amuState);
        return harmonic / PHI;
    }
    
    private double calculatePhiResonance() {
        if (amuState == 0) return 0;
        double ratio = abhiState / amuState;
        double distance = Math.abs(ratio - PHI);
        return Math.max(0, 1 - distance / PHI);
    }
    
    private double calculateSystemLevel() {
        return currentBridgeStability * calculatePhiResonance();
    }
    
    private void setupEventListeners() {
        resonateButton.setOnClickListener(v -> resonateSystem());
        generateDnaButton.setOnClickListener(v -> generateDnaSequence());
        evolveButton.setOnClickListener(v -> simulateEvolution());
        connectBackendButton.setOnClickListener(v -> connectToBackend());
    }
    
    private void resonateSystem() {
        String intention = intentionInput.getText().toString().trim();
        if (intention.isEmpty()) {
            Toast.makeText(this, "Please enter an intention", Toast.LENGTH_SHORT).show();
            return;
        }
        
        setStatus("Resonating system with intention...");
        
        // Resonate system with intention
        double intentionFreq = (double)(intention.hashCode() % 100) / 100.0;
        double energy = 0.8;
        
        abhiState += energy * intentionFreq * PHI;
        amuState += energy * intentionFreq * PHI_INVERSE;
        
        // Normalize states
        normalizeStates();
        
        currentBridgeStability = calculateBridgeStability();
        updateSystemDisplay();
        
        setStatus("System resonance complete");
        intentionInput.setText("");
    }
    
    private void normalizeStates() {
        double total = abhiState + amuState;
        if (total > 0) {
            abhiState = total * PHI / (PHI + 1);
            amuState = total * 1 / (PHI + 1);
        }
    }
    
    private void generateDnaSequence() {
        setStatus("Generating DNA sequence from system state...");
        
        // Generate DNA sequence from system state
        String[] bases = {"A", "B", "H", "I"}; // Awareness, Bridge, Harmony, Integration
        StringBuilder dna = new StringBuilder();
        
        // Generate 32-base sequence using phi-resonance
        for (int i = 0; i < 32; i++) {
            int phiIndex = (int)((i * PHI) % bases.length);
            dna.append(bases[phiIndex]);
        }
        
        currentDna = dna.toString();
        dnaSequence.setText("DNA: " + currentDna);
        
        // Calculate DNA fitness
        double fitness = calculateDnaFitness(currentDna);
        
        setStatus(String.format("DNA generated - Fitness: %.6f", fitness));
    }
    
    private double calculateDnaFitness(String dna) {
        double[] baseWeights = {1.0, PHI_INVERSE, PHI, 1.0}; // A, B, H, I
        double fitness = 0;
        
        for (char base : dna.toCharArray()) {
            switch (base) {
                case 'A': fitness += baseWeights[0]; break;
                case 'B': fitness += baseWeights[1]; break;
                case 'H': fitness += baseWeights[2]; break;
                case 'I': fitness += baseWeights[3]; break;
            }
        }
        
        double normalizedFitness = fitness / dna.length();
        return Math.min(1.0, normalizedFitness / PHI);
    }
    
    private void simulateEvolution() {
        if (currentDna.isEmpty()) {
            generateDnaSequence();
        }
        
        setStatus("Starting evolution simulation...");
        evolutionProgress.setVisibility(View.VISIBLE);
        evolutionProgress.setProgress(0);
        
        new EvolutionTask().execute();
    }
    
    private class EvolutionTask extends AsyncTask<Void, Integer, Void> {
        @Override
        protected Void doInBackground(Void... voids) {
            int generations = 5;
            double currentFitness = calculateDnaFitness(currentDna);
            
            for (int gen = 1; gen <= generations; gen++) {
                try {
                    Thread.sleep(1000); // Simulate processing time
                    
                    // Simulate evolution improvement
                    double improvement = Math.random() * 0.05 * (gen / (double)generations);
                    currentFitness = Math.min(1.0, currentFitness + improvement);
                    
                    // Enhance system during evolution
                    double enhancement = 1 + (improvement * PHI_INVERSE);
                    abhiState *= enhancement;
                    amuState *= enhancement;
                    
                    publishProgress((gen * 100) / generations);
                    
                } catch (InterruptedException e) {
                    break;
                }
            }
            
            return null;
        }
        
        @Override
        protected void onProgressUpdate(Integer... progress) {
            evolutionProgress.setProgress(progress[0]);
        }
        
        @Override
        protected void onPostExecute(Void result) {
            evolutionProgress.setVisibility(View.GONE);
            currentBridgeStability = calculateBridgeStability();
            updateSystemDisplay();
            setStatus("Evolution complete! System enhanced.");
        }
    }
    
    private void connectToBackend() {
        setStatus("Connecting to DODO backend...");
        connectBackendButton.setEnabled(false);
        
        new BackendConnectionTask().execute();
    }
    
    private class BackendConnectionTask extends AsyncTask<Void, Void, Boolean> {
        private String errorMessage = "";
        
        @Override
        protected Boolean doInBackground(Void... voids) {
            try {
                // Test backend connection
                URL url = new URL(BACKEND_URL + "/health");
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("GET");
                connection.setConnectTimeout(5000);
                connection.setReadTimeout(5000);
                
                if (connection.getResponseCode() == 200) {
                    // Try to register/authenticate
                    return authenticateWithBackend();
                } else {
                    errorMessage = "Backend responded with status: " + connection.getResponseCode();
                    return false;
                }
                
            } catch (Exception e) {
                errorMessage = "Cannot connect to backend: " + e.getMessage();
                return false;
            }
        }
        
        private boolean authenticateWithBackend() {
            try {
                // Register with backend
                URL url = new URL(BACKEND_URL + "/api/auth/register");
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("POST");
                connection.setRequestProperty("Content-Type", "application/json");
                connection.setDoOutput(true);
                
                JSONObject registerData = new JSONObject();
                registerData.put("username", "dodo_android_user");
                registerData.put("email", "android@dodo.app");
                registerData.put("password", "phi_resonance_" + System.currentTimeMillis());
                
                OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream());
                writer.write(registerData.toString());
                writer.close();
                
                if (connection.getResponseCode() == 201 || connection.getResponseCode() == 409) {
                    // Registration successful or user exists, try login
                    return loginToBackend();
                }
                
                return false;
                
            } catch (Exception e) {
                errorMessage = "Authentication failed: " + e.getMessage();
                return false;
            }
        }
        
        private boolean loginToBackend() {
            try {
                URL url = new URL(BACKEND_URL + "/api/auth/login");
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("POST");
                connection.setRequestProperty("Content-Type", "application/json");
                connection.setDoOutput(true);
                
                JSONObject loginData = new JSONObject();
                loginData.put("email", "android@dodo.app");
                loginData.put("password", "default_password");
                
                OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream());
                writer.write(loginData.toString());
                writer.close();
                
                if (connection.getResponseCode() == 200) {
                    BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                    String response = reader.readLine();
                    JSONObject responseData = new JSONObject(response);
                    authToken = responseData.optString("token", "authenticated");
                    return true;
                }
                
                return false;
                
            } catch (Exception e) {
                errorMessage = "Login failed: " + e.getMessage();
                return false;
            }
        }
        
        @Override
        protected void onPostExecute(Boolean success) {
            connectBackendButton.setEnabled(true);
            
            if (success) {
                backendConnected = true;
                setStatus("Connected to DODO backend successfully!");
                connectBackendButton.setText("BACKEND CONNECTED");
                
                // Send DNA to backend if available
                if (!currentDna.isEmpty()) {
                    sendDnaToBackend();
                }
            } else {
                setStatus("Failed to connect: " + errorMessage);
                Toast.makeText(DodoAnalyticsApp.this, "Connection failed: " + errorMessage, Toast.LENGTH_LONG).show();
            }
        }
    }
    
    private void sendDnaToBackend() {
        if (!backendConnected || currentDna.isEmpty()) return;
        
        new SendDnaTask().execute();
    }
    
    private class SendDnaTask extends AsyncTask<Void, Void, Boolean> {
        @Override
        protected Boolean doInBackground(Void... voids) {
            try {
                URL url = new URL(BACKEND_URL + "/api/dna/generate");
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("POST");
                connection.setRequestProperty("Content-Type", "application/json");
                connection.setRequestProperty("Authorization", "Bearer " + authToken);
                connection.setDoOutput(true);
                
                JSONObject dnaData = new JSONObject();
                dnaData.put("seedPattern", currentDna);
                dnaData.put("evolutionTarget", "system_enhancement");
                
                OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream());
                writer.write(dnaData.toString());
                writer.close();
                
                return connection.getResponseCode() == 200;
                
            } catch (Exception e) {
                return false;
            }
        }
        
        @Override
        protected void onPostExecute(Boolean success) {
            if (success) {
                setStatus("DNA synchronized with backend");
            }
        }
    }
    
    private void setStatus(String message) {
        runOnUiThread(() -> statusText.setText(message));
    }
    
    @Override
    protected void onDestroy() {
        super.onDestroy();
        // Clean up resources
    }
}