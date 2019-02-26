# Reconjurer

> Documentation soon...
> (or not)

---

## Designing a level

Level are stored in `data/levels/` as `.txt` files.
There is two types of level: _operator-based_ and _set-based_.

### _operator-based_:

An _operator-based_ level allow the creation of a level in which every riddle is an operation in **addition** (`+`), **subtraction** (`-`) or **multiplication** (`x`).
You may define the range of each operators and each operand as parameters of each operation.

```.txt
_x: 6,10; 1,5
```

In this example, every riddle are multiplication where the first operand is a random integer from 6 to 10 and the second from 1 to 5 (both end are included).

### _set-based_:

To define a _set-based_ level, you only need to provide a list of entries in the level file.
If the entry contains a colon (`:`), the text preceding it is displayed above the enemy and the text following should be typed to kill the enemy (e.g. translation levels).
Else, both text (above enemy and to type) are the same (e.g. allowing typo-training levels).

```.txt
color: couleur
red: rouge
green: vert
blue: bleu
yellow: jaune
orange
```

Note: any leading or trailing spaces, or surrounding the colon, are striped-off and not accounted for.

### parameters:

The available parameters allows you to adapt your level by changing some options:

+ **+**, **-**, **x**: see _operator-based_ levels;
+ **t**: time: delay between spawns, in frames;
+ **l**: starting level: (see levels **TODO**);
+ **w**: wave size: (same).

A parameters is always precessed by an underscore / low-dash (`_`) as follow:

```.txt
_t: 60, 120
_w: 10
```

In the above example, the time parameter is set to a minimum of 60 frame and a maximum of 120 frames, which mean the spawn of the an enemy will occurre from 1 to 2 second after the previous one.
As the wave size parameter is 10, the player will level after 10 strikes.

---
