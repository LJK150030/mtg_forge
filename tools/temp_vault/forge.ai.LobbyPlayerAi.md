---
aliases:
  - LobbyPlayerAi
tags:
  - java/class
  - module/forge-ai
  - pkg/forge/ai
fqn: forge.ai.LobbyPlayerAi
package: forge.ai
module: forge-ai
kind: Class
---

# LobbyPlayerAi

**Package:** `forge.ai` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class LobbyPlayerAi {
        -String aiProfile
        -boolean rotateProfileEachGame
        -boolean useSimulation
        +setAiProfile(String profileName) void
        +getAiProfile() String
        +setRotateProfileEachGame(boolean rotateProfileEachGame) void
        -createControllerFor(Player ai) PlayerControllerAi
        +createMindSlaveController(Player master, Player slave) PlayerController
        +createIngamePlayer(Game game, int id) Player
        +hear(LobbyPlayer player, String message) void
        +LobbyPlayerAi(String name, Set~AIOption~ options)
    }
    LobbyPlayerAi --|> LobbyPlayer : extends
    LobbyPlayerAi ..|> IGameEntitiesFactory : implements
    LobbyPlayerAi ..> AIOption : uses
    LobbyPlayerAi ..> Game : uses
    LobbyPlayerAi ..> Player : uses
    LobbyPlayerAi ..> PlayerController : uses
    LobbyPlayerAi ..> PlayerControllerAi : uses
```

## Relationships
**Extends:**
- [[forge.LobbyPlayer|LobbyPlayer]]
**Implements:**
- [[forge.game.player.IGameEntitiesFactory|IGameEntitiesFactory]]
**Uses:**
- [[forge.ai.AIOption|AIOption]]
- [[forge.ai.PlayerControllerAi|PlayerControllerAi]]
- [[forge.game.Game|Game]]
- [[forge.game.player.Player|Player]]
- [[forge.game.player.PlayerController|PlayerController]]


## Design Description

`LobbyPlayerAi` represents an AI-controlled seat in the game lobby, holding the configuration—AI profile name, per-game profile rotation, and a simulation flag—that determines how a computer opponent is set up and behaves. Extending `LobbyPlayer`, it provides the AI variant of a lobby participant, while its implementation of `IGameEntitiesFactory` makes it responsible for constructing the engine-side `Player` and its decision-making controller.

Its core responsibility is building `PlayerControllerAi` instances through the private `createControllerFor` helper, reused for both ordinary in-game players and mind-slave control of another player, propagating the simulation setting into each. The design cleanly separates lobby-level identity and preferences from the runtime objects it produces, optionally randomizing the profile each game via `AiProfileUtil`. The no-op `hear` override deliberately leaves the local AI "deaf," signaling it has no need to process chat messages.

## Source
`forge-ai/src/main/java/forge/ai/LobbyPlayerAi.java`

```java
package forge.ai;

import java.util.Set;

import forge.LobbyPlayer;
import forge.game.Game;
import forge.game.player.IGameEntitiesFactory;
import forge.game.player.Player;
import forge.game.player.PlayerController;
import org.tinylog.Logger;

public class LobbyPlayerAi extends LobbyPlayer implements IGameEntitiesFactory {

    private String aiProfile = "";
    private boolean rotateProfileEachGame;
    private boolean useSimulation;

    public LobbyPlayerAi(String name, Set<AIOption> options) {
        super(name);
        if (options != null && options.contains(AIOption.USE_SIMULATION)) {
            this.useSimulation = true;
        }
    }

    public void setAiProfile(String profileName) {
        Logger.debug("[AI Preferences] " + name + " using profile " + profileName);
        aiProfile = profileName;
    }
    public String getAiProfile() {
        return aiProfile;
    }

    public void setRotateProfileEachGame(boolean rotateProfileEachGame) {
        this.rotateProfileEachGame = rotateProfileEachGame;
    }

    private PlayerControllerAi createControllerFor(Player ai) {
        PlayerControllerAi result = new PlayerControllerAi(ai.getGame(), ai, this);
        result.setUseSimulation(useSimulation);
        return result;
    }

    @Override
    public PlayerController createMindSlaveController(Player master, Player slave) {
        return createControllerFor(slave);
    }

    @Override
    public Player createIngamePlayer(Game game, final int id) {
        Player ai = new Player(getName(), game, id);
        ai.setFirstController(createControllerFor(ai));

        if (rotateProfileEachGame) {
            setAiProfile(AiProfileUtil.getRandomProfile());
        }
        return ai;
    }

    @Override
    public void hear(LobbyPlayer player, String message) { /* Local AI is deaf. */ }
}
```
