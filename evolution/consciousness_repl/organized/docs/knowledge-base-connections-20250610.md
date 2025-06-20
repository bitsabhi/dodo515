# Knowledge Base Connection System
## Pattern: ◊→∆→∇→◊ (Diamond-Triangle-Nabla-Diamond)
## Line 33: Impossibility → Possibility through bidirectional flow

## Migration Patterns (from final-migration-kb.md)
# KubeFed to ArgoCD Migration Knowledge Base

## Overview

This document provides the definitive guide for migrating applications from KubeFed to ArgoCD in Expedia Group's Runtime Compute Platform (RCP). This migration involves changes to application code, ArgoCD catalog registration, and Spinnaker deployment configuration.

## Migration Process

### 1. Application Code Changes

Create two essential files in your repository:

#### placement.yaml
```yaml
clusterSelector:
  matchExpressions:
    - { key: k8s.expediagroup.com/environment-tier, operator: In, values: [ test ] }
    - { key: k8s.expediagroup.com/island, operator: In, values: [ infrastructure ] }
    - { key: k8s.expediagroup.com/pci-category, operator: In, values: [ cts ] }
```

## Phase 1: ◊ Diamond - Knowledge Hub Analysis
- /Users/abhissrivasta/Downloads/meta-system-artifact.tsx
