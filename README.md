Modified Media Player
---
Media Player is an addon for Garry's Mod which features several media streaming services able to be played synchronously in multiplayer.

Different from the original repository, various features have been added or fixed.

You can check the [original repository here](https://github.com/toriato/glua-mediaplayer).

## Added or Modified Features
- Allows YouTube Shorts URLs
- Select preferred language for YouTube subtitles
- Support for Invidious to play YouTube videos (for bypassing age restrictions, etc...)

## Added client-side ConVars
- `mediaplayer_subtitles` (string)  
  Specify your preferred subtitles using a [two-letter ISO country code](https://www.iban.com/country-codes).  
  **Default**: *Language selected in the game (`gmod_language`)*
- `mediaplayer_invidious_instance` (string)  
  Specify your preferred instance to use when using Invidious.  
  **Default**: *""* (default values are specified in the web app as *[vid.puffyan.us](https://vid.puffyan.us)*)
- `mediaplayer_invidious_enable` (boolean)  
  Use Invidious instead of the YouTube iFrame when playing YouTube videos.  
  **Default**: *0*
