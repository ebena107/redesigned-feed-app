# Feed Formulation Optimizer - Quick Reference

**Status:** Planning Phase  
**Version:** 1.0.0 (Planned)  
**Last Updated:** 2026-01-01

---

## Overview

The Feed Formulation Optimizer is a new AI-powered feature that automatically generates optimal feed formulations based on nutritional requirements, ingredient availability, and cost constraints.

### Key Benefits
- ⚡ **Fast**: Optimize formulations in seconds instead of hours
- 💰 **Cost-Effective**: Minimize feed costs while meeting nutritional requirements
- 🎯 **Accurate**: Ensure all nutritional constraints are met
- 🔒 **Safe**: Respect ingredient inclusion limits and avoid toxicity

---

## Quick Links

- **[Implementation Plan](FEED_OPTIMIZER_IMPLEMENTATION_PLAN.md)** - Detailed technical plan with architecture and components
- **[Task Breakdown](FEED_OPTIMIZER_TASKS.md)** - 150+ granular tasks organized into 9 phases
- **[Formulation Workflow Test](../test/integration/formulation_workflow_test.dart)** - Existing integration tests for formulation validation

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Optimizer Screen (UI)                    │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Animal   │→ │Constraints│→ │Ingredients│→ │ Results  │   │
│  │Selection │  │   Input   │  │ Selection │  │ Display  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                   Optimizer Provider (State)                 │
│  • optimizationRequestProvider                               │
│  • optimizationResultProvider                                │
│  • savedOptimizationsProvider                                │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│              FormulationOptimizerService (Logic)             │
│  ┌──────────────────┐  ┌──────────────────┐                │
│  │ Constraint       │  │ Formulation      │                 │
│  │ Validator        │  │ Scorer           │                 │
│  └──────────────────┘  └──────────────────┘                │
│                 Linear Programming Solver                    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                              │
│  • OptimizationConstraint (Freezed)                          │
│  • OptimizationRequest (Freezed)                             │
│  • OptimizationResult (Freezed)                              │
│  • Feed (Extended with optimization fields)                  │
└─────────────────────────────────────────────────────────────┘
```

---

## Key Components

### Core Services
| Service | Purpose | Location |
|---------|---------|----------|
| `FormulationOptimizerService` | Main optimization engine using Linear Programming | `lib/src/features/optimizer/services/` |
| `ConstraintValidator` | Validates constraints before/after optimization | `lib/src/features/optimizer/services/` |
| `FormulationScorer` | Scores formulations by cost, quality, safety | `lib/src/features/optimizer/services/` |

### Data Models
| Model | Type | Purpose |
|-------|------|---------|
| `OptimizationConstraint` | Freezed | Single nutritional constraint (min/max/exact) |
| `OptimizationRequest` | Freezed | Complete optimization request with all parameters |
| `OptimizationResult` | Freezed | Optimization results with ingredient proportions |
| `Feed` (extended) | Freezed + Isar | Feed model with optimization metadata |

### UI Components
| Widget | Purpose |
|--------|---------|
| `OptimizerScreen` | Main screen with stepper/wizard layout |
| `ConstraintInputWidget` | Add/edit nutritional constraints |
| `IngredientSelectionWidget` | Select ingredients and set prices |
| `OptimizationResultCard` | Display optimization results |
| `ConstraintTemplateDialog` | Load pre-defined constraint templates |

---

## Optimization Algorithm

**Method:** Linear Programming (Simplex Algorithm)

**Objective Function:**
```
Minimize: Σ(ingredient_i × price_i)
```

**Constraints:**
```
Subject to:
  - Σ(ingredient_i × nutrient_j) >= min_requirement_j  (for all nutrients)
  - Σ(ingredient_i × nutrient_j) <= max_requirement_j  (for all nutrients)
  - min_inclusion_i <= ingredient_i <= max_inclusion_i  (for all ingredients)
  - Σ(ingredient_i) = 100  (total formulation = 100%)
  - ingredient_i >= 0  (non-negativity)
```

---

## Constraint Templates

Pre-defined templates based on industry standards:

| Template | Source | Animal Types |
|----------|--------|--------------|
| NRC 2012 Swine | National Research Council | Pigs (by growth stage) |
| NRC 2016 Poultry | National Research Council | Chickens, Turkeys (by age) |
| CVB 2021 | Centraal Veevoeder Bureau | Multiple species |
| Custom | User-defined | Any |

**Template Storage:** `assets/optimizer_templates/*.json`

---

## Integration Points

### Existing Features
- **Ingredients Database** → Provides nutritional data for optimization
- **Price Management** → Provides current ingredient prices
- **Feed Management** → Saves optimized formulations as feeds
- **Reports & PDF** → Exports optimized formulations

### New Routes
- `/optimizer` - Main optimizer screen
- `/optimizer/results/:id` - View saved optimization results
- `/optimizer/templates` - Manage constraint templates

---

## Testing Strategy

### Test Coverage
- **Unit Tests:** Core optimization algorithm, constraint validation, scoring
- **Integration Tests:** End-to-end optimization workflow, database integration
- **Widget Tests:** UI components, user interactions
- **Manual Tests:** Real-world scenarios, localization, performance

### Performance Targets
- Optimization time: **< 10 seconds** (20 ingredients, 15 constraints)
- Memory usage: **Stable** (no leaks)
- UI responsiveness: **Maintained** during optimization

---

## Implementation Timeline

| Phase | Duration | Status |
|-------|----------|--------|
| Phase 1: Planning & Documentation | 1 week | ✅ In Progress |
| Phase 2: Core Algorithm Development | 1 week | ⏳ Pending |
| Phase 3: Data Layer & Models | 3 days | ⏳ Pending |
| Phase 4: Business Logic Layer | 4 days | ⏳ Pending |
| Phase 5: UI Components | 1 week | ⏳ Pending |
| Phase 6: Integration | 3 days | ⏳ Pending |
| Phase 7: Localization | 2 days | ⏳ Pending |
| Phase 8: Testing & Validation | 1 week | ⏳ Pending |
| Phase 9: Documentation & Deployment | 3 days | ⏳ Pending |
| **Total** | **4-6 weeks** | **1% Complete** |

---

## Dependencies

### New Packages Required
```yaml
dependencies:
  simplex: ^1.0.0  # Linear Programming solver (Option 1)
  # OR
  lpsolve: ^5.5.0  # Native LP solver (Option 2 - better performance)
```

### Architecture Notes
- **No Freezed**: Project uses regular Dart classes (Freezed was removed in previous modernization)
- **Manual Serialization**: All models implement `toJson`/`fromJson` manually
- **No Code Generation**: No `build_runner` steps required for optimizer models

### Database Changes
- **Feed model migration** required (adds 4 new fields)
- **Backward compatible** with existing feeds

---

## Localization

### Languages Supported
The app currently supports 8 languages, and all optimizer UI must be translated:

- 🇺🇸 **English** (en) - Template language
- 🇪🇸 **Spanish** (es)
- 🇵🇹 **Portuguese** (pt)
- 🇫🇷 **French** (fr)
- 🇹🇿 **Swahili** (sw)
- 🇳🇬 **Yoruba** (yo)
- 🇵🇭 **Filipino** (fil)
- 🇵🇭 **Tagalog** (tl)

### New Translation Keys
- ~35 new strings for optimizer UI
- All strings must be added to all 8 ARB files
- Localization files: `lib/l10n/app_*.arb`

---

## Future Enhancements (Post-V1)

- 🎯 Multi-objective optimization (Pareto frontier)
- 📊 Sensitivity analysis (what-if scenarios)
- 🔄 Batch optimization (multiple formulations)
- 🤖 ML-based formulation suggestions
- 🌐 External ingredient price API integration
- 📈 Formulation comparison tool

---

## Key Decisions Required

> [!IMPORTANT]
> **Pending Decisions:**
> 1. **Algorithm:** Linear Programming vs. Genetic Algorithms?
> 2. **Dependencies:** Which LP solver library to use?
> 3. **Pricing:** Use current prices, custom prices, or both?

---

## Related Documentation

- [Implementation Plan](FEED_OPTIMIZER_IMPLEMENTATION_PLAN.md) - Full technical specification
- [Task Breakdown](FEED_OPTIMIZER_TASKS.md) - Detailed task checklist
- [README.md](../README.md) - Main project documentation
- [PHASE_5_COMPREHENSIVE_ROADMAP.md](PHASE_5_COMPREHENSIVE_ROADMAP.md) - Overall project roadmap

---

**Document Version:** 1.0  
**Created:** 2026-01-01  
**Author:** Development Team
