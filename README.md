# The Hidden Academy

---
![Banner](https://cdn.discordapp.com/attachments/601130066407194634/907622048329789490/unknown.png)

## Notes

- **Unstable release**
- Alpha version of the game; access restricted to Provost+ (and sometimes opened for staff) for testing during development stages.
- 5 Public test sessions took place between August & September, where all members of the community could visit the academy.

---

## Reported Issues

### Lag:

- Heavy lag around the map, however frames were frequently dropped when around the academy's placement.

### Ragdoll:

- Falling from small heights would sometimes cause health damage & irreversible ragdoll; **this has since been resolved.**
- Sometimes the ragdoll system would incorrectly weld the player's torso & rootpart, and would cause a visible separation between the upper & lower torso; **this has since been resolved.**
- The ragdoll system will sometimes cause players to glitch through small walls and floors when re-entering an idle state after recovering from being ragdolled.

### Tools:

- Tools were sometimes not given upon spawn; **this has since been resolved.**
- Tools would sometimes glitch players to the testing rooms when equipped; **this has since been resolved**.
- When equipping tools, the player would experience a significant delay (1-2 seconds) between clicking to equip the tool & the tool being actually equipped; **this has since been resolved.**

### Interactions:

- Some doors open at bizarre angles, specifically the dungeon & upstairs doors.
- Cafeteria switch that controls the vertical sliding door worked, but did not have any effect on the sliding door.
- Doors were able to be spammed open/closed, causing lag for lots of players and a horrible noise repeatedly playing; **a 1-second cooldown has been implemented.**
- Doors that were already open when a player joined the game were not updated when the academy chunks were loaded in; **this has since been resolved.**

### Stats:

- Sprinting time would sometimes deplete too fast, or not at all; **this has since been resolved.**
- Hunger depletes too slowly; **this has since been resolved.**

### Insanity:

- When swimming as a hollow, players would often fall through the water and out of the world; **this has since been resolved.**

### Staff:

- The staff phone system sometimes errored, rendering the entire tool useless; **this has since been resolved.**
- Exclusive area doors were not removed for staff; **this has since been resolved.**

---

## Vulnerabilities

<aside>
🚨 If you happen to find a vulnerability, you should contact the Oversight team immediately with as much detail regarding the issue as possible, as well as detailed instructions of how to reproduce the vulnerability & how you found out about it.

</aside>

- During the July 10th test session, an ill-natured user gained access to a Discord webhook of a private staff channel via an insecure module. Rather than reporting this vulnerability to a member of the Oversight team, the user exploited the vulnerability by sending 100s of webhook messages to the channel containing derogative terms; the Academy Oversight team shut down the situation quickly and we have taken the necessary precautions to prevent a similar situation from re-occurring.