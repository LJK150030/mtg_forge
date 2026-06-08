---
aliases:
  - PeekAndRevealEffect
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/ability/effects
fqn: forge.game.ability.effects.PeekAndRevealEffect
package: forge.game.ability.effects
module: forge-game
kind: Class
---

# PeekAndRevealEffect

**Package:** `forge.game.ability.effects` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class PeekAndRevealEffect {
        #getStackDescription(SpellAbility sa) String
        +resolve(SpellAbility sa) void
    }
    PeekAndRevealEffect --|> SpellAbilityEffect : extends
    PeekAndRevealEffect ..> Card : uses
    PeekAndRevealEffect ..> CardCollection : uses
    PeekAndRevealEffect ..> CardCollectionView : uses
    PeekAndRevealEffect ..> Player : uses
    PeekAndRevealEffect ..> PlayerZone : uses
    PeekAndRevealEffect ..> SpellAbility : uses
    PeekAndRevealEffect ..> ZoneType : uses
```

## Relationships
**Extends:**
- [[forge.game.ability.SpellAbilityEffect|SpellAbilityEffect]]
**Uses:**
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.card.CardCollectionView|CardCollectionView]]
- [[forge.game.player.Player|Player]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.zone.PlayerZone|PlayerZone]]
- [[forge.game.zone.ZoneType|ZoneType]]

## Design Description

PeekAndRevealEffect is a concrete SpellAbilityEffect that resolves "peek and reveal" abilities: the activating player looks at the top card(s) of one or more players' libraries and optionally reveals matching cards. It overrides `getStackDescription` to assemble a grammatically adaptive summary (singular/plural, "looks at" vs. "reveals", whose library) and `resolve` to apply the effect. It collaborates with Player and PlayerZone/ZoneType to locate the source zone (defaulting to Library), and with Card, CardCollection, and CardCollectionView to gather peeked cards and filter the revealable subset via CardLists and a RevealValid pattern.

The design is parameter-driven: optional SpellAbility params (PeekAmount, NoPeek, NoReveal, RevealOptional, RememberRevealed, ImprintRevealed, RememberPeeked) toggle behavior so a single class serves many card scripts. Remembered or imprinted cards are stored as last-known-information copies via CardCopyService, decoupling tracked references from subsequent zone movement.

## Source
`forge-game/src/main/java/forge/game/ability/effects/PeekAndRevealEffect.java`

```java
package forge.game.ability.effects;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.common.collect.Maps;

import forge.game.ability.AbilityUtils;
import forge.game.ability.SpellAbilityEffect;
import forge.game.card.*;
import forge.game.player.Player;
import forge.game.spellability.SpellAbility;
import forge.game.zone.PlayerZone;
import forge.game.zone.ZoneType;
import forge.util.Lang;
import forge.util.Localizer;

public class PeekAndRevealEffect extends SpellAbilityEffect {

    @Override
    protected String getStackDescription(SpellAbility sa) {
        final Player peeker = sa.getActivatingPlayer();
        final int numPeek = sa.hasParam("PeekAmount") ?
                AbilityUtils.calculateAmount(sa.getHostCard(), sa.getParam("PeekAmount"), sa) : 1;
        final String verb = sa.hasParam("NoReveal") || sa.hasParam("RevealOptional") ? " looks at " :
                " reveals ";
        final String defined = sa.getParamOrDefault("Defined", "");
        final List<Player> libraryPlayers = getDefinedPlayersOrTargeted(sa);
        final String defString = Lang.joinHomogenous(libraryPlayers);
        String who = defined.equals("Player") && verb.equals(" reveals ") ? "Each player" :
                sa.hasParam("NoPeek") && verb.equals(" reveals ") ? defString : "";
        String whose = defined.equals("Player") && verb.equals(" looks at ") ? "each player's"
                : libraryPlayers.size() == 1 && libraryPlayers.get(0) == peeker ? "their" :
                defString + "'s";

        final StringBuilder sb = new StringBuilder();

        sb.append(who.isEmpty() ? peeker : who);
        sb.append(verb).append("the top ");
        sb.append(numPeek > 1 ? Lang.getNumeral(numPeek) + " cards " : "card ").append("of ").append(whose);
        sb.append(" library.");

        return sb.toString();
    }

    /* (non-Javadoc)
     * @see forge.card.abilityfactory.SpellEffect#resolve(forge.card.spellability.SpellAbility)
     */
    @Override
    public void resolve(SpellAbility sa) {
        final Card source = sa.getHostCard();
        final boolean rememberRevealed = sa.hasParam("RememberRevealed");
        final boolean imprintRevealed = sa.hasParam("ImprintRevealed");
        final boolean noPeek = sa.hasParam("NoPeek");
        String revealValid = sa.getParamOrDefault("RevealValid", "Card");
        String peekAmount = sa.getParamOrDefault("PeekAmount", "1");
        int numPeek = AbilityUtils.calculateAmount(source, peekAmount, sa);
        final ZoneType srcZone = sa.hasParam("SourceZone") ? ZoneType.smartValueOf(sa.getParam("SourceZone")) : ZoneType.Library;

        List<Player> srcZonePlayers = getDefinedPlayersOrTargeted(sa);
        final Player peekingPlayer = sa.getActivatingPlayer();

        for (Player zoneToPeek : srcZonePlayers) {
            final PlayerZone playerZone = zoneToPeek.getZone(srcZone);
            numPeek = Math.min(numPeek, playerZone.size());

            CardCollection peekCards = new CardCollection();
            for (int i = 0; i < numPeek; i++) {
                peekCards.add(playerZone.get(i));
            }

            Map<String, Object> params = new HashMap<>();
            params.put("Revealed", peekCards);

            CardCollectionView revealableCards = CardLists.getValidCards(peekCards, revealValid, peekingPlayer, source, sa);
            boolean doReveal = !sa.hasParam("NoReveal") && !revealableCards.isEmpty();
            if (!noPeek) {
                peekingPlayer.getController().reveal(peekCards, srcZone, zoneToPeek,
                        source.getTranslatedName() + " - " +
                                Localizer.getInstance().getMessage("lblLookingCardFrom"));
            }

            if (doReveal && sa.hasParam("RevealOptional"))
                doReveal = peekingPlayer.getController().confirmAction(sa, null, Localizer.getInstance().getMessage("lblRevealCardToOtherPlayers"), params);

            if (doReveal) {
                peekingPlayer.getGame().getAction().reveal(revealableCards, srcZone, zoneToPeek, !noPeek,
                        source.getTranslatedName() + " - " +
                                Localizer.getInstance().getMessage("lblRevealingCardFrom"));

                if (rememberRevealed) {
                    Map<Integer, Card> cachedMap = Maps.newHashMap();
                    for (Card c : revealableCards) {
                        source.addRemembered(CardCopyService.getLKICopy(c, cachedMap));
                    }
                }
                if (imprintRevealed) {
                    Map<Integer, Card> cachedMap = Maps.newHashMap();
                    for (Card c : revealableCards) {
                        source.addImprintedCard(CardCopyService.getLKICopy(c, cachedMap));
                    }
                }
            } else if (sa.hasParam("RememberPeeked")) {
                Map<Integer, Card> cachedMap = Maps.newHashMap();
                for (Card c : revealableCards) {
                    source.addRemembered(CardCopyService.getLKICopy(c, cachedMap));
                }
            }
        }
    }

}
```
