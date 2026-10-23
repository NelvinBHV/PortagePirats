HD overrides for ZGloom

Place custom PNG replacements in:
  ${XDG_DATA_HOME:-~/.local/share}/zgloom/hd

Supported override paths:
  hd/txts/<name>.png
    Replaces wall textures like txt1_0, txt3_4, floor1, roof2.

  hd/objs/<name>/<frame>.png
    Replaces sprite frames for objects and gore sets.
    Examples:
      hd/objs/marine/0.png
      hd/objs/marine/1.png
      hd/objs/marine2/0.png

  hd/pics/<name>.png
    Replaces fullscreen title and intermission pictures.
    Examples:
      hd/pics/title.png
      hd/pics/blackmagic.png
      hd/pics/hell.png

  hd/misc/healthbar.png
  hd/misc/healthbaron.png
  hd/misc/weaponbar.png
    Replaces the HUD bars.

  hd/misc/weapons/<frame>.png
    Replaces the five weapon indicator icons in the HUD.

  hd/misc/gun/<frame>.png
    Replaces weapon HUD sprite frames loaded from misc/gun.bin.

Notes:
  - PNG alpha is respected. Transparent pixels stay transparent.
  - Sprite frame count is still defined by the original data files.
  - Wall and flat overrides are sampled directly by the renderer.
