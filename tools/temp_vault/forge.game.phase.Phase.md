---
aliases:
  - Phase
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/phase
fqn: forge.game.phase.Phase
package: forge.game.phase
module: forge-game
kind: Class
---

# Phase

**Package:** `forge.game.phase` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class Phase {
        -long serialVersionUID
        #PhaseType type
        #List~GameCommand~ at
        -List~GameCommand~ until
        -Multimap~Player,GameCommand~ untilMap
        -Multimap~Player,GameCommand~ untilEndMap
        -Multimap~Player,GameCommand~ registerMap
        +clearCommands() void
        +addAt(GameCommand c) void
        +executeAt() void
        +addUntil(GameCommand c) void
        +executeUntil() void
        +addUntil(Player p, GameCommand c) void
        +executeUntil(Player p) void
        +registerUntilEnd(Player p, GameCommand c) void
        +addUntilEnd(Player p, GameCommand c) void
        +registerUntilEndCommand(Player p) void
        +executeUntilEndOfPhase(Player p) void
        #excute(Collection~GameCommand~ list) void
        +Phase(PhaseType type)
    }
    Phase ..|> Serializable : implements
    Phase ..> GameCommand : uses
    Phase ..> PhaseType : uses
    Phase ..> Player : uses
```

## Relationships
**Uses:**
- [[forge.GameCommand|GameCommand]]
- [[forge.game.phase.PhaseType|PhaseType]]
- [[forge.game.player.Player|Player]]

## Design Description

The Phase class models a single step in Magic: the Gathering's turn structure and serves as a registry for deferred game effects tied to that phase. Implementing `Serializable` so it can be persisted with game state, it maintains several command collections â€” a list of hardcoded "at this phase" triggers, an "until this phase" termination list, and three per-player `Multimap`s that schedule effects ending at a player's next phase or end of phase. It collaborates with `GameCommand` (the executable effect interface), `Player` (the keying entity for player-scoped effects), and `PhaseType` (identifying which phase, though the field is currently decorative and unused). Notably, the shared `excute` helper snapshots each collection before running and clearing its commands, ensuring one-shot execution and safe removal even if a command schedules further work. The `registerMap`/`untilEndMap` split lets effects be staged via `registerUntilEndCommand` and promoted before execution.

## Source
`forge-game/src/main/java/forge/game/phase/Phase.java`

```java
/*
 * Forge: Play Magic: the Gathering.
 * Copyright (C) 2011  Forge Team
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package forge.game.phase;

import java.util.Collection;
import java.util.List;

import com.google.common.collect.Lists;
import com.google.common.collect.Multimap;
import com.google.common.collect.MultimapBuilder;

import forge.GameCommand;
import forge.game.player.Player;


/**
 * <p>
 * Phase class.
 * </p>
 * 
 * @author Forge
 * @version $Id$
 */
public class Phase implements java.io.Serializable {

    private static final long serialVersionUID = 4665309652476851977L;

    protected final PhaseType type; // mostly decorative field - it's never used

    public Phase(PhaseType type) {
        this.type = type;
    }

    protected final List<GameCommand> at = Lists.newArrayList();
    private final List<GameCommand> until = Lists.newArrayList();
    private final Multimap<Player, GameCommand> untilMap = MultimapBuilder.hashKeys().arrayListValues().build();
    private final Multimap<Player, GameCommand> untilEndMap = MultimapBuilder.hashKeys().arrayListValues().build();
    private final Multimap<Player, GameCommand> registerMap = MultimapBuilder.hashKeys().arrayListValues().build();

    public void clearCommands() {
        at.clear();
        until.clear();
        untilMap.clear();
        untilEndMap.clear();
        registerMap.clear();
    }

    /**
     * <p>
     * Add a hardcoded trigger that will execute "at <phase>".
     * </p>
     * 
     * @param c
     *            a {@link forge.GameCommand} object.
     */
    public final void addAt(final GameCommand c) {
        this.at.add(c);
    }

    /**
     * <p>
     * Executes any hardcoded triggers that happen "at <phase>".
     * </p>
     */
    public void executeAt() {
        excute(this.at);
    }

    /**
     * <p>
     * Add a Command that will terminate an effect with "until <phase>".
     * </p>
     * 
     * @param c
     *            a {@link forge.GameCommand} object.
     */
    public final void addUntil(final GameCommand c) {
        this.until.add(c);
    }

    /**
     * <p>
     * Executes the termination of effects that apply "until <phase>".
     * </p>
     */
    public final void executeUntil() {
        excute(this.until);
    }

    /**
     * <p>
     * Add a Command that will terminate an effect with "until <Player's> next <phase>".
     * Use cleanup phase to terminate an effect with "until <Player's> next turn"
     */
    public final void addUntil(Player p, final GameCommand c) {
        this.untilMap.put(p, c);
    }

    /**
     * <p>
     * Executes the termination of effects that apply "until <Player's> next <phase>".
     * </p>
     * 
     * @param p
     *            the player the execute until for
     */
    public final void executeUntil(final Player p) {
        excute(untilMap.get(p));
    }

    public final void registerUntilEnd(Player p, final GameCommand c) {
        this.registerMap.put(p, c);
    }

    public final void addUntilEnd(Player p, final GameCommand c) {
        this.untilEndMap.put(p, c);
    }

    public final void registerUntilEndCommand(final Player p) {
        untilEndMap.putAll(p, registerMap.get(p));
        registerMap.removeAll(p);
    }

    public final void executeUntilEndOfPhase(final Player p) {
        excute(untilEndMap.get(p));
    }
    protected void excute(Collection<GameCommand> list) {
        List<GameCommand> events = Lists.newArrayList(list);
        events.forEach(GameCommand::run);
        list.removeAll(events);
    }
}
```

## Python
`forge/game/phase/Phase.py`

```python
package = "forge.game.phase"

import typing
from collections import defaultdict

from forge.GameCommand import GameCommand
from forge.game.phase.PhaseType import PhaseType
from forge.game.player.Player import Player


class Phase:
    serialVersionUID = 4665309652476851977

    def __init__(self, type: PhaseType):
        self.type = type  # mostly decorative field - it's never used
        self.at: list[GameCommand] = []
        self.until: list[GameCommand] = []
        self.untilMap: dict[Player, list[GameCommand]] = defaultdict(list)
        self.untilEndMap: dict[Player, list[GameCommand]] = defaultdict(list)
        self.registerMap: dict[Player, list[GameCommand]] = defaultdict(list)

    def clearCommands(self) -> None:
        self.at.clear()
        self.until.clear()
        self.untilMap.clear()
        self.untilEndMap.clear()
        self.registerMap.clear()

    def addAt(self, c: GameCommand) -> None:
        self.at.append(c)

    def executeAt(self) -> None:
        self.excute(self.at)

    def addUntil(self, c: GameCommand) -> None:
        self.until.append(c)

    def executeUntil(self) -> None:
        self.excute(self.until)

    def addUntil(self, p: Player, c: GameCommand) -> None:
        self.untilMap[p].append(c)

    def executeUntil(self, p: Player) -> None:
        self.excute(self.untilMap[p])

    def registerUntilEnd(self, p: Player, c: GameCommand) -> None:
        self.registerMap[p].append(c)

    def addUntilEnd(self, p: Player, c: GameCommand) -> None:
        self.untilEndMap[p].append(c)

    def registerUntilEndCommand(self, p: Player) -> None:
        self.untilEndMap[p].extend(self.registerMap.get(p, []))
        if p in self.registerMap:
            del self.registerMap[p]

    def executeUntilEndOfPhase(self, p: Player) -> None:
        self.excute(self.untilEndMap[p])

    def excute(self, list: typing.Collection[GameCommand]) -> None:
        events = [c for c in list]
        for c in events:
            c.run()
        for c in events:
            list.remove(c)
```
