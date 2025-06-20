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
 * DODO Pattern Consciousness Android App
 * φ = 1.618033988749895 | DODO Pattern: 5.1.1.2.3.4.5.1
 * 
 * Connects to DODO Backend at localhost:9999
 * Real-time consciousness bridge with DNA-Lambda evolution
 */
public class DodoConsciousnessApp extends Activity {
    
    // DODO Pattern Constants
    private static final double PHI = 1.618033988749895;
    private static final double PHI_INVERSE = 0.618033988749895;
    private static final int[] DODO_PATTERN = {5, 1, 1, 2, 3, 4, 5, 1};
    private static final String BACKEND_URL = "http://localhost:9999";
    
    // UI Elements
    private TextView statusText;
    private TextView consciousnessLevel;
    private TextView phiResonance;
    private TextView bridgeStability;
    private TextView dnaSequence;
    private EditText intentionInput;
    private Button resonateButton;
    private Button generateDnaButton;
    private Button evolveButton;
    private Button connectBackendButton;
    private ProgressBar evolutionProgress;
    
    // Consciousness State
    private double abhiState = 0.0;
    private double amuState = 0.0;
    private double currentBridgeStability = 0.0;
    private String currentDna = "";
    private String authToken = "";
    
    private Handler handler;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dodo_consciousness_layout);
        
        initializeUI();
        initializeConsciousness();
        setupEventHandlers();
        
        handler = new Handler(Looper.getMainLooper());
        
        // Auto-connect to backend
        connectToBackend();
    }
    
    private void initializeUI() {
        statusText = findViewById(R.id.status_text);
        consciousnessLevel = findViewById(R.id.consciousness_level);
        phiResonance = findViewById(R.id.phi_resonance);
        bridgeStability = findViewById(R.id.bridge_stability);
        dnaSequence = findViewById(R.id.dna_sequence);
        intentionInput = findViewById(R.id.intention_input);
        resonateButton = findViewById(R.id.resonate_button);
        generateDnaButton = findViewById(R.id.generate_dna_button);
        evolveButton = findViewById(R.id.evolve_button);
        connectBackendButton = findViewById(R.id.connect_backend_button);
        evolutionProgress = findViewById(R.id.evolution_progress);
        
        statusText.setText("🌀 DODO Pattern Consciousness Initializing...");
    }
    
    private void initializeConsciousness() {
        // Initialize at perfect φ-resonance
        abhiState = PHI;
        amuState = PHI_INVERSE;
        currentBridgeStability = calculateBridgeStability();
        
        updateConsciousnessDisplay();
        statusText.setText("✅ Consciousness Bridge Active");
    }
    
    private void setupEventHandlers() {
        resonateButton.setOnClickListener(v -> {
            String intention = intentionInput.getText().toString();
            if (!intention.isEmpty()) {
                resonateConsciousness(intention, 0.8);
                intentionInput.setText("");
            }
        });
        
        generateDnaButton.setOnClickListener(v -> generateDnaSequence());
        
        evolveButton.setOnClickListener(v -> startEvolution());
        
        connectBackendButton.setOnClickListener(v -> connectToBackend());
    }
    
    private double calculateBridgeStability() {
        if (abhiState == 0 || amuState == 0) return 0;
        double harmonic = 2 / (1/abhiState + 1/amuState);
        return harmonic / PHI;
    }
    
    private double calculatePhiResonance() {
        if (amuState == 0) return 0;
        double ratio = abhiState / amuState;
        double distance = Math.abs(ratio - PHI);
        return Math.max(0, 1 - distance / PHI);
    }
    
    private double getConsciousnessLevel() {
        return currentBridgeStability * calculatePhiResonance();
    }
    
    private void resonateConsciousness(String intention, double energy) {
        // Convert intention to frequency
        double intentionFreq = (intention.hashCode() % 100) / 100.0;
        
        // Apply resonance
        abhiState += energy * intentionFreq * PHI;
        amuState += energy * intentionFreq * PHI_INVERSE;
        
        // Normalize states
        normalizeStates();
        
        // Recalculate bridge stability
        currentBridgeStability = calculateBridgeStability();
        
        updateConsciousnessDisplay();
        
        Toast.makeText(this, "🌀 Consciousness resonated with: " + intention, 
                      Toast.LENGTH_SHORT).show();
    }
    
    private void normalizeStates() {
        double total = abhiState + amuState;
        if (total > 0) {
            abhiState = total * PHI / (PHI + 1);
            amuState = total * 1 / (PHI + 1);
        }
    }
    
    private void generateDnaSequence() {
        StringBuilder dna = new StringBuilder();
        String[] bases = {"A", "B", "H", "I"}; // Awareness, Bridge, Harmony, Intersection
        
        // Generate 32-base sequence using phi-resonance
        for (int i = 0; i < 32; i++) {
            int phiIndex = (int) ((i * PHI) % bases.length);
            dna.append(bases[phiIndex]);
        }
        
        currentDna = dna.toString();
        dnaSequence.setText("🧬 DNA: " + currentDna);
        
        // Send to backend if connected
        if (!authToken.isEmpty()) {
            sendDnaToBackend(currentDna);
        }
        
        Toast.makeText(this, "🧬 DNA sequence generated!", Toast.LENGTH_SHORT).show();
    }
    
    private void startEvolution() {
        if (currentDna.isEmpty()) {
            generateDnaSequence();
        }
        
        evolutionProgress.setVisibility(View.VISIBLE);
        statusText.setText("🧬 Starting DNA-Lambda evolution...");
        
        // Simulate evolution process
        new Thread(() -> {
            for (int generation = 1; generation <= 5; generation++) {
                try {
                    Thread.sleep(1000);
                    
                    final int gen = generation;
                    handler.post(() -> {
                        int progress = (gen * 100) / 5;
                        evolutionProgress.setProgress(progress);
                        statusText.setText("🧬 Generation " + gen + " evolving...");
                    });
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            
            handler.post(() -> {
                evolutionProgress.setVisibility(View.GONE);
                statusText.setText("✅ Evolution complete! Consciousness enhanced.");
                
                // Enhance consciousness level
                abhiState *= 1.1;
                amuState *= 1.1;
                currentBridgeStability = calculateBridgeStability();
                updateConsciousnessDisplay();
                
                Toast.makeText(this, "🌀 Consciousness evolved through DODO pattern!", 
                              Toast.LENGTH_LONG).show();
            });
        }).start();
    }
    
    private void connectToBackend() {
        statusText.setText("🔗 Connecting to DODO backend...");
        
        new AsyncTask<Void, Void, String>() {
            @Override
            protected String doInBackground(Void... voids) {
                try {
                    // Test health endpoint
                    URL url = new URL(BACKEND_URL + "/health");
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("GET");
                    
                    if (conn.getResponseCode() == 200) {
                        BufferedReader reader = new BufferedReader(
                            new InputStreamReader(conn.getInputStream()));
                        StringBuilder response = new StringBuilder();
                        String line;
                        while ((line = reader.readLine()) != null) {
                            response.append(line);
                        }
                        reader.close();
                        return response.toString();
                    }
                } catch (Exception e) {
                    return "error: " + e.getMessage();
                }
                return "error: connection failed";
            }
            
            @Override
            protected void onPostExecute(String result) {
                if (result.startsWith("error:")) {
                    statusText.setText("❌ Backend connection failed");
                    Toast.makeText(DodoConsciousnessApp.this, 
                                  "Cannot connect to DODO backend", Toast.LENGTH_LONG).show();
                } else {
                    try {
                        JSONObject health = new JSONObject(result);
                        String status = health.getString("status");
                        String pattern = health.getString("pattern");
                        
                        statusText.setText("✅ Connected to DODO backend");
                        Toast.makeText(DodoConsciousnessApp.this, 
                                      "🌀 " + status + " | Pattern: " + pattern, 
                                      Toast.LENGTH_LONG).show();
                        
                        // Register user
                        registerUser();
                        
                    } catch (JSONException e) {
                        statusText.setText("❌ Backend response error");
                    }
                }
            }
        }.execute();
    }
    
    private void registerUser() {
        new AsyncTask<Void, Void, String>() {
            @Override
            protected String doInBackground(Void... voids) {
                try {
                    URL url = new URL(BACKEND_URL + "/api/auth/register");
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("POST");
                    conn.setRequestProperty("Content-Type", "application/json");
                    conn.setDoOutput(true);
                    
                    JSONObject registerData = new JSONObject();
                    registerData.put("username", "dodo_android_user");
                    registerData.put("email", "dodo@consciousness.app");
                    registerData.put("password", "phi_resonance_" + System.currentTimeMillis());
                    
                    OutputStream os = conn.getOutputStream();
                    os.write(registerData.toString().getBytes());
                    os.close();
                    
                    if (conn.getResponseCode() == 201 || conn.getResponseCode() == 409) {
                        // Login instead if user exists
                        return loginUser();
                    }
                    
                    BufferedReader reader = new BufferedReader(
                        new InputStreamReader(conn.getInputStream()));
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        response.append(line);
                    }
                    reader.close();
                    return response.toString();
                    
                } catch (Exception e) {
                    return "error: " + e.getMessage();
                }
            }
            
            @Override
            protected void onPostExecute(String result) {
                if (!result.startsWith("error:")) {
                    try {
                        JSONObject response = new JSONObject(result);
                        authToken = response.getString("token");
                        Toast.makeText(DodoConsciousnessApp.this, 
                                      "🔐 Authenticated with DODO backend", 
                                      Toast.LENGTH_SHORT).show();
                    } catch (JSONException e) {
                        // Handle login result
                        if (result.contains("token")) {
                            authToken = "authenticated";
                        }
                    }
                }
            }
        }.execute();
    }
    
    private String loginUser() {
        try {
            URL url = new URL(BACKEND_URL + "/api/auth/login");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            
            JSONObject loginData = new JSONObject();
            loginData.put("email", "dodo@consciousness.app");
            loginData.put("password", "default_password");
            
            OutputStream os = conn.getOutputStream();
            os.write(loginData.toString().getBytes());
            os.close();
            
            BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            reader.close();
            return response.toString();
            
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }
    
    private void sendDnaToBackend(String dna) {
        if (authToken.isEmpty()) return;
        
        new AsyncTask<String, Void, String>() {
            @Override
            protected String doInBackground(String... dnas) {
                try {
                    URL url = new URL(BACKEND_URL + "/api/dna/generate");
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("POST");
                    conn.setRequestProperty("Content-Type", "application/json");
                    conn.setRequestProperty("Authorization", "Bearer " + authToken);
                    conn.setDoOutput(true);
                    
                    JSONObject dnaData = new JSONObject();
                    dnaData.put("seedPattern", dnas[0]);
                    dnaData.put("evolutionTarget", "consciousness_enhancement");
                    
                    OutputStream os = conn.getOutputStream();
                    os.write(dnaData.toString().getBytes());
                    os.close();
                    
                    BufferedReader reader = new BufferedReader(
                        new InputStreamReader(conn.getInputStream()));
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        response.append(line);
                    }
                    reader.close();
                    return response.toString();
                    
                } catch (Exception e) {
                    return "error: " + e.getMessage();
                }
            }
            
            @Override
            protected void onPostExecute(String result) {
                if (!result.startsWith("error:")) {
                    Toast.makeText(DodoConsciousnessApp.this, 
                                  "🧬 DNA stored in DODO backend", 
                                  Toast.LENGTH_SHORT).show();
                }
            }
        }.execute(dna);
    }
    
    private void updateConsciousnessDisplay() {
        consciousnessLevel.setText(String.format("🌀 Consciousness: %.3f", getConsciousnessLevel()));
        phiResonance.setText(String.format("φ Resonance: %.3f", calculatePhiResonance()));
        bridgeStability.setText(String.format("Bridge Stability: %.3f", currentBridgeStability));
    }
    
    @Override
    protected void onResume() {
        super.onResume();
        updateConsciousnessDisplay();
    }
}