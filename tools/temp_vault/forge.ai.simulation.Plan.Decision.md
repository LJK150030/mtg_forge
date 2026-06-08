---
aliases:
  - Decision
tags:
  - java/class
  - module/forge-ai
  - pkg/forge/ai/simulation
fqn: forge.ai.simulation.Plan.Decision
package: forge.ai.simulation
module: forge-ai
kind: Class
---

# Decision

**Package:** `forge.ai.simulation` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class Decision {
        ~Decision prevDecision
        ~Score initialScore
        ~SpellAbilityRef saRef
        ~Integer xMana
        ~MultiTargetSelector.Targets targets
        ~List~String~ choices
        ~int[] modes
        ~String modesStr
        +toString(boolean showHostCard) String
        +toString() String
        +Decision(Score initialScore, Decision prevDecision, SpellAbilityRef saRef)
        +Decision(Score initialScore, Decision prevDecision, MultiTargetSelector.Targets targets)
        +Decision(Score initialScore, Decision prevDecision, Card choice)
        +Decision(Score initialScore, Decision prevDecision, int[] modes, String modesStr)
    }
    Decision ..> Card : uses
    Decision ..> MultiTargetSelector : uses
    Decision ..> Score : uses
    Decision ..> SpellAbilityRef : uses
    Decision ..> Targets : uses
```

## Relationships
**Uses:**
- [[forge.ai.simulation.GameStateEvaluator.Score|Score]]
- [[forge.ai.simulation.MultiTargetSelector|MultiTargetSelector]]
- [[forge.ai.simulation.MultiTargetSelector.Targets|Targets]]
- [[forge.ai.simulation.Plan.SpellAbilityRef|SpellAbilityRef]]
- [[forge.game.card.Card|Card]]

## Design Description

A nested static helper that captures one step of an AI simulation plan. Each `Decision` records the `Score` (`initialScore`) the game state held at that point and links backward to its `prevDecision`, forming a singly-linked chain that reconstructs the full sequence of AI choices. Its four constructors model the mutually exclusive kinds of choice a step can represent: casting/activating a referenced ability (`SpellAbilityRef`, optionally with an X-mana value), selecting targets (`MultiTargetSelector.Targets`), naming a card (`Card`), or picking modes (`int[]` plus a display string).

As a plain data holder it carries no behavior beyond `toString`, which renders a human-readable trace of the step — splicing the X value into the ability text and appending targets and chosen names. The package-private fields and `modesStr` "for human pretty-print consumption only" signal it is an internal record for the simulation evaluator, not a public API.

## Source
`forge-ai/src/main/java/forge/ai/simulation/Plan.java` â€” declaration excerpt

```java
    public static class Decision {
        final Decision prevDecision;
        final Score initialScore;

        final SpellAbilityRef saRef;
        Integer xMana;
        MultiTargetSelector.Targets targets;
        List<String> choices;
        int[] modes;
        String modesStr; // for human pretty-print consumption only

        public Decision(Score initialScore, Decision prevDecision, SpellAbilityRef saRef) {
            this.initialScore = initialScore;
            this.prevDecision = prevDecision;
            this.saRef = saRef;
        }

        public Decision(Score initialScore, Decision prevDecision, MultiTargetSelector.Targets targets) {
            this.initialScore = initialScore;
            this.prevDecision = prevDecision;
            this.saRef = null;
            this.targets = targets;
        }

        public Decision(Score initialScore, Decision prevDecision, Card choice) {
            this.initialScore = initialScore;
            this.prevDecision = prevDecision;
            this.saRef = null;
            this.choices = new ArrayList<>();
            this.choices.add(choice.getName());
        }

        public Decision(Score initialScore, Decision prevDecision, int[] modes, String modesStr) {
            this.initialScore = initialScore;
            this.prevDecision = prevDecision;
            this.saRef = null;
            this.modes = modes;
            this.modesStr = modesStr;
        }

        public String toString(boolean showHostCard) {
            StringBuilder sb = new StringBuilder();
            if (!showHostCard) {
                sb.append("[initScore=").append(initialScore).append(" ");
            }
            if (modesStr != null) {
                sb.append(modesStr);
            } else {
                String sa = saRef.toString(showHostCard);
                if (xMana != null) {
                    sa = sa.replace("(X=0)", "(X=" + xMana + ")");
                }
                sb.append(sa);
            }
            if (targets != null) {
                sb.append(" (targets: ").append(targets).append(")");
            }
            if (choices != null) {
                sb.append(" (chosen: ").append(Joiner.on(", ").join(choices)).append(")");
            }
            if (!showHostCard) {
                sb.append("]");
            }
            return sb.toString();
        }

        @Override
        public String toString() {
            return toString(false);
        }
    }
```
