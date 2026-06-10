---
aliases:
  - ChooseColorEffect
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/ability/effects
fqn: forge.game.ability.effects.ChooseColorEffect
package: forge.game.ability.effects
module: forge-game
kind: Class
---

# ChooseColorEffect

**Package:** `forge.game.ability.effects` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ChooseColorEffect {
        #getStackDescription(SpellAbility sa) String
        +resolve(SpellAbility sa) void
    }
    ChooseColorEffect --|> SpellAbilityEffect : extends
    ChooseColorEffect ..> Card : uses
    ChooseColorEffect ..> Color : uses
    ChooseColorEffect ..> ColorSet : uses
    ChooseColorEffect ..> MagicColor : uses
    ChooseColorEffect ..> Player : uses
    ChooseColorEffect ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.ability.SpellAbilityEffect|SpellAbilityEffect]]
**Uses:**
- [[forge.card.ColorSet|ColorSet]]
- [[forge.card.MagicColor|MagicColor]]
- [[forge.card.MagicColor.Color|Color]]
- [[forge.game.card.Card|Card]]
- [[forge.game.player.Player|Player]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

`ChooseColorEffect` is a concrete `SpellAbilityEffect` that resolves abilities asking one or more players to pick a color. It overrides `getStackDescription` to produce the readable "X chooses a color" summary and `resolve` to perform the selection, keeping the behavior data-driven through `SpellAbility` parameters rather than hard-coded rules.

In `resolve` it assembles the candidate list from `MagicColor` constants, then refines it via `Choices`, `ColorsFrom` (deriving a `ColorSet` from referenced `Card`s, short-circuiting if colorless), and `Exclude`. For each target `Player` it derives minimum and maximum counts from flags such as `UpTo`, `TwoColors`, and `OrColors`, selects a localized prompt, and either chooses randomly or delegates to the player's controller. The chosen `ColorSet` is recorded on the host `Card` via `setChosenColors`, collaborating with `ColorSet`, `MagicColor`, and the controller abstraction to centralize count logic and localization while leaving the actual decision to the player.

## Source
`forge-game/src/main/java/forge/game/ability/effects/ChooseColorEffect.java`

```java
package forge.game.ability.effects;

import forge.card.ColorSet;
import forge.card.MagicColor;
import forge.game.ability.AbilityUtils;
import forge.game.ability.SpellAbilityEffect;
import forge.game.card.Card;
import forge.game.card.CardUtil;
import forge.game.player.Player;
import forge.game.spellability.SpellAbility;
import forge.util.Aggregates;
import forge.util.Lang;
import forge.util.Localizer;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class ChooseColorEffect extends SpellAbilityEffect {

    @Override
    protected String getStackDescription(SpellAbility sa) {
        final StringBuilder sb = new StringBuilder();

        sb.append(Lang.joinHomogenous(getTargetPlayers(sa)));

        sb.append(" chooses a color");
        if (sa.hasParam("OrColors")) {
            sb.append(" or colors");
        }
        sb.append(".");

        return sb.toString();
    }

    @Override
    public void resolve(SpellAbility sa) {
        final Card card = sa.getHostCard();

        List<String> colorChoices = new ArrayList<>(MagicColor.Constant.ONLY_COLORS);
        if (sa.hasParam("Choices")) {
            String[] restrictedChoices = sa.getParam("Choices").split(",");
            colorChoices = Arrays.asList(restrictedChoices);
        }
        if (sa.hasParam("ColorsFrom")) {
            ColorSet cs = CardUtil.getColorsFromCards(AbilityUtils.getDefinedCards(card, sa.getParam("ColorsFrom"), sa));
            if (cs.isColorless()) {
                return;
            }
            colorChoices = cs.stream().map(Object::toString).collect(Collectors.toCollection(ArrayList::new));
        }
        if (sa.hasParam("Exclude")) {
            for (String s : sa.getParam("Exclude").split(",")) {
                colorChoices.remove(s);
            }
        }

        for (Player p : getTargetPlayers(sa)) {
            if (!p.isInGame()) {
                p = getNewChooser(sa, p);
            }

            int cntMin = sa.hasParam("UpTo") ? 0 : sa.hasParam("TwoColors") ? 2 : 1;
            int cntMax = sa.hasParam("TwoColors") ? 2 : sa.hasParam("OrColors") ? colorChoices.size() : 1;
            String prompt = null;
            if (cntMax == 1) {
                prompt = Localizer.getInstance().getMessage("lblChooseAColor");
            } else if (cntMax > cntMin) {
                if (cntMax >= MagicColor.NUMBER_OR_COLORS) {
                    prompt = Localizer.getInstance().getMessage("lblAtLastChooseNumColors", Lang.getNumeral(cntMin));
                } else {
                    prompt = Localizer.getInstance().getMessage("lblChooseSpecifiedRangeColors", Lang.getNumeral(cntMin), Lang.getNumeral(cntMax));
                }
            } else {
                prompt = Localizer.getInstance().getMessage("lblChooseNColors", Lang.getNumeral(cntMax));
            }
            ColorSet chosenColors = ColorSet.C;
            Player noNotify = p;
            if (sa.hasParam("Random")) {
                String choice;
                for (int i=0; i<cntMin; i++) {
                    choice = Aggregates.random(colorChoices);
                    colorChoices.remove(choice);
                    chosenColors = ColorSet.combine(chosenColors, ColorSet.fromNames(choice));
                }
                noNotify = null;
            } else {
                chosenColors = p.getController().chooseColors(prompt, sa, cntMin, cntMax, ColorSet.fromNames(colorChoices));
            }
            if (chosenColors.isColorless()) {
                return;
            }
            card.setChosenColors(chosenColors.stream().map(MagicColor.Color::getName).collect(Collectors.toList()));
            String desc = Lang.joinHomogenous(chosenColors.stream().map(MagicColor.Color::getTranslatedName).collect(Collectors.toList()));
            p.getGame().getAction().notifyOfValue(sa, p, desc, noNotify);
        }
    }
}
```

## Python
`forge/game/ability/effects/ChooseColorEffect.py`

```python
from forge.card.ColorSet import ColorSet
from forge.card.MagicColor import MagicColor
from forge.card.MagicColor.Color import Color
from forge.game.ability.AbilityUtils import AbilityUtils
from forge.game.ability.SpellAbilityEffect import SpellAbilityEffect
from forge.game.card.Card import Card
from forge.game.card.CardUtil import CardUtil
from forge.game.player.Player import Player
from forge.game.spellability.SpellAbility import SpellAbility
from forge.util.Aggregates import Aggregates
from forge.util.Lang import Lang
from forge.util.Localizer import Localizer


class ChooseColorEffect(SpellAbilityEffect):

    def getStackDescription(self, sa: SpellAbility) -> str:
        sb = []

        sb.append(Lang.joinHomogenous(self.getTargetPlayers(sa)))

        sb.append(" chooses a color")
        if sa.hasParam("OrColors"):
            sb.append(" or colors")
        sb.append(".")

        return "".join(sb)

    def resolve(self, sa: SpellAbility) -> None:
        card = sa.getHostCard()

        colorChoices = list(MagicColor.Constant.ONLY_COLORS)
        if sa.hasParam("Choices"):
            restrictedChoices = sa.getParam("Choices").split(",")
            colorChoices = list(restrictedChoices)
        if sa.hasParam("ColorsFrom"):
            cs = CardUtil.getColorsFromCards(AbilityUtils.getDefinedCards(card, sa.getParam("ColorsFrom"), sa))
            if cs.isColorless():
                return
            colorChoices = [str(c) for c in cs.stream()]
        if sa.hasParam("Exclude"):
            for s in sa.getParam("Exclude").split(","):
                if s in colorChoices:
                    colorChoices.remove(s)

        for p in self.getTargetPlayers(sa):
            if not p.isInGame():
                p = self.getNewChooser(sa, p)

            cntMin = 0 if sa.hasParam("UpTo") else 2 if sa.hasParam("TwoColors") else 1
            cntMax = 2 if sa.hasParam("TwoColors") else len(colorChoices) if sa.hasParam("OrColors") else 1
            prompt = None
            if cntMax == 1:
                prompt = Localizer.getInstance().getMessage("lblChooseAColor")
            elif cntMax > cntMin:
                if cntMax >= MagicColor.NUMBER_OR_COLORS:
                    prompt = Localizer.getInstance().getMessage("lblAtLastChooseNumColors", Lang.getNumeral(cntMin))
                else:
                    prompt = Localizer.getInstance().getMessage("lblChooseSpecifiedRangeColors", Lang.getNumeral(cntMin), Lang.getNumeral(cntMax))
            else:
                prompt = Localizer.getInstance().getMessage("lblChooseNColors", Lang.getNumeral(cntMax))
            chosenColors = ColorSet.C
            noNotify = p
            if sa.hasParam("Random"):
                for i in range(cntMin):
                    choice = Aggregates.random(colorChoices)
                    colorChoices.remove(choice)
                    chosenColors = ColorSet.combine(chosenColors, ColorSet.fromNames(choice))
                noNotify = None
            else:
                chosenColors = p.getController().chooseColors(prompt, sa, cntMin, cntMax, ColorSet.fromNames(colorChoices))
            if chosenColors.isColorless():
                return
            card.setChosenColors([Color.getName(c) for c in chosenColors.stream()])
            desc = Lang.joinHomogenous([Color.getTranslatedName(c) for c in chosenColors.stream()])
            p.getGame().getAction().notifyOfValue(sa, p, desc, noNotify)
```
