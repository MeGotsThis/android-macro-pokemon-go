# Trading Pokemon Setup for the Android Macro

This macro automates basic Pokemon GO trades. It searches for a trade button, opens the trade UI, selects a Pokemon, advances through the trade screens, and handles common warning dialogs and trade failures automatically.

> [!NOTE]
> The macro is designed to run as fast as possible and stops automatically when there are no tradable Pokemon left.

## Contents

- [Why use this over basic auto-tapper?](#why-use-this-over-basic-auto-tapper)
- [What you need](#what-you-need)
- [Compatibility](#compatibility)
- [Installing/updating the macro](#installingupdating-the-macro)
- [In-game setup](#in-game-setup)
- [Macro settings](#macro-settings)
- [Automatic handling](#what-the-macro-handles-automatically)
- [Other questions](#other-questions)
- [Example](#example)

## Why use this over basic auto-tapper?

This trade auto tapper can handle multiple scenarios such as dynamax Pokemon and XXS/XXL Pokemon. This will also run faster than the basic auto-tapper since it does not need to rely on the other device/phone to be in the same screen for timing. The design of the macro is to run as fast as possible. The macro will stop trading automatically when there are no tradable Pokemon left.

## What you need

| Requirement | Details |
| --- | --- |
| [Android Macro](https://androidmacro.com/) | Installed and working on both devices |
| Android Macro Pro | Purchased |
| Pokemon GO | Installed, logged in, and set to English |
| Trainer accounts | Two accounts, each with at least one Pokemon available to trade |

## Compatibility

| Component | Supported versions/devices |
| --- | --- |
| Pokemon GO | 0.420.0+ |
| Android Macro | 1.0.0.36+ |
| Android version | Android 15+ |
| Phone type | Slab phones (non-foldable), including Samsung Galaxy S-series/A-series and Pixel phones |

Other phones may be compatible if they have a similar form factor. Android 14 and older may need additional tweaks; instructions will be added in the future.

## Installing/updating the macro

> [!TIP]
> Importing a newer file replaces the existing version of the macro.

1. [Download](https://github.com/MeGotsThis/android-macro-pokemon-go/releases) the macro
2. Open Android Macro
   
   [<img src="../Screenshots/1-AndroidMacro.png" alt="Android Macro" width="90" height="200">](../Screenshots/1-AndroidMacro.png)
3. Click the + button on the bottom right
   
   [<img src="../Screenshots/2-ImportLocalMacro.png" alt="Import Macro" width="90" height="200">](../Screenshots/2-ImportLocalMacro.png)
4. Select Local Import
5. Select the file

## In-game setup

Before starting the macro, prepare both devices/phones like this:

1. Open Pokemon GO.
2. Find your trade partner from your friends list.
   
   [<img src="Screenshots/1-TrainerProfile.png" alt="Trainer Profile" width="90" height="200">](Screenshots/1-TrainerProfile.png)
3. (Optional/Recommended) Manually complete one trade using the desired Pokemon search string. This helps prepare the search filter for the macro.
   
   [<img src="Screenshots/2-TradeSearch.png" alt="Trade Search Screen" width="90" height="200">](Screenshots/2-TradeSearch.png)
   - This will also trigger a friendship interaction if one hasn't happened yet. This may make you both Lucky Friends, giving you the opportunity to complete the Lucky Trade before running the macro.
4. Load the macro by pressing the green play button on both devices/phones.
   
   [<img src="Screenshots/3-AndroidMacro.png" alt="Android Macro" width="90" height="200">](Screenshots/3-AndroidMacro.png)
   - To switch macros, press the toggle button on the right side of the macro.
5. Run the macro with "Play Script".
   - The trade button must be visible on the trainer profile
   
   [<img src="Screenshots/4-LoadedMacro.png" alt="Macro Load" width="90" height="200">](Screenshots/4-LoadedMacro.png)
   
   [<img src="Screenshots/5-RunMacro.png" alt="Run Macro" width="90" height="200">](Screenshots/5-RunMacro.png)
6. Fill in the settings; this only needs to be done once unless you want the settings to be changed. The macro remembers the settings for future runs.
   
   [<img src="Screenshots/6-MacroDialog.png" alt="Run Macro" width="90" height="200">](Screenshots/6-MacroDialog.png)

## Macro settings

When the macro starts, it opens a small dialog with these settings:

| Setting | What it does |
| --- | --- |
| **Number of trades** | Sets the maximum number of trades the macro should try. |
| **Auto stop at 0 Pokemon Searched** | Stops the macro when it finds no valid Pokemon to trade. |
| **Number of trade retries** | Sets how many retry attempts are made after a failed trade. |
| **Auto Yes on warning trade** | Accepts warning prompts automatically, typically for Dynamax or Mega-evolved Pokemon. |
| **Auto Unfavorite** | Removes the favorite mark from Pokemon when needed. |
| **Do Special Trade** | Allows the macro to continue through special trade prompts. |

### Recommended starting values

| Setting | Recommendation |
| --- | --- |
| Number of trades | 1 to 100 |
| Number of trade retries | 2 to 5 |
| Auto Yes on warning trade | Enabled |
| Auto Unfavorite | Enabled if you want the macro to unmark Pokemon before trading |
| Do Special Trade | Disabled unless you specifically want special trades |

## What the macro handles automatically

This script includes logic for common trade states, including:

- Daily trade limit reached
- Trade cooldown or out-of-range errors
- Canceled trades
- Temporary trade unavailability
- Warning dialogs
- Special trade confirmation screens
- Auto-stop when zero Pokemon are available
- Retry loops for failed trade attempts

## Other questions

### How long do 100 trades take?

On my two phones, doing 100 trades usually takes under 40 minutes. Pokemon GO has trade cooldown and the macro will not be able to run faster than the cooldown.

### Can this run on tablets or foldable phones?

Most likely not. For tablets, Pokemon GO scales the UI slightly differently compared to slab phones. Personally I don't have a foldable phone to test with.

If there is demand for tablet/foldable phones, I can create a new macro with more general device support, but it will run slower. Submit a ticket [here](https://github.com/MeGotsThis/android-macro-pokemon-go/issues/new).

### The macro ran into an issue. Where do I submit a bug ticket?

Submit the issue [here](https://github.com/MeGotsThis/android-macro-pokemon-go/issues/new). Please provide what device you are using and some screenshots. I might ask for more screenshots.

### Does this support other languages?

Not yet completely. For the most part, the macro can do the trades fine. Issues may occur when Pokemon GO displays a dialog with text like trade was cancelled. This is the only language dependent part of the macro. Trading mega-evolved/dynamax Pokemon warning dialog is not affected. Submit an [issue](https://github.com/MeGotsThis/android-macro-pokemon-go/issues/new) as a suggestion.

### When sharing screen with Android Macro, do I share one app or whole screen?

This is your choice.

**Reasons and side effects for one app:**

- You want to see your notifications in full.
- The macro may do phantom taps if you switch to another app.

**Reasons and side effects for the whole screen:**

- The macro may accidentally press if you switch apps.
- Notifications may contain sensitive content. See [Android 15 screen-sharing protections](https://www.androidpolice.com/android-15-screen-sharing-protections/).

### Can this run on one phone while the other phone use basic auto tapper?

Yes. The macro does not depend on timing on trades. The intent of the macro is to run as fast as possible so it is almost always faster than the wait time on the basic auto tapper.

### Can this run on one phone while the other phone manually trade?

Yes. The macro does not depend on timing on trades. So you can take as long as you like.

### What settings do you normally use?

[<img src="Screenshots/6-MacroDialog.png" alt="Run Macro" width="180" height="400">](Screenshots/6-MacroDialog.png)

**48 trades** - This is for a few reasons:

- Potentially trade with two different people with about half the trades done each. (49 trades: 1 manually to setup + 48 through the macro)
- There is a break in time to catch my house spawns or berry a gym
- I usually prefer to finish most of my trades before going out, usually after midnight. By not doing all my trades (usually doing 98 from both manual and macro), I can do a special trade any time of the day.

**Other settings:**

- I don't want to think about the warning prompt due to mega-evolved Pokemon or dynamax Pokemon
- Sometimes I forget to unfavorite a Pokemon in the tag
- I don't want the macro to accidentally do my special trade
- Sometimes the tag/search does not have the full 48 Pokemon to trade, so auto stopping helps

## Example

10 trades

https://github.com/user-attachments/assets/baf19623-7160-4aaa-bdc3-d5f953ad8cfa

