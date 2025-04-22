# YGO Duel Tracker

**YGO Duel Tracker** is an AutoHotkey (AHK) application designed to track duels in the Yu-Gi-Oh! game. It provides an intuitive user interface to manage life points, decks, victories, and card information.

## Features

### Duel Management
- **45-Minute Timer**: Built-in tournament timer with start/pause/reset controls
- **Life Points (LP) Tracking**: 
  - Adjust LP with customizable increments
  - Half-LP button for quick calculations
  - Auto-saves LP values between sessions
- **Victory Tracking**: Best-of-3 counter for each player
- **Tournament Mode**: 
  - Track rounds (W/L/D)
  - Auto-reset between matches

### Card Search Engine (New in v1.2)
- **YGOPRODeck API Integration**: Search 10,000+ Yu-Gi-Oh! cards
- **High-Resolution Images**: Displays card artwork
- **Detailed Card Info**: 
  - Name, Type, Attribute/Race
  - ATK/DEF/Level/Link values
  - Full card effect text
- **Local Image Caching**: Faster subsequent searches

### Enhanced Interface (v1.2)
- **Tabbed Layout**: Organized into Duel/Card Search/Log sections
- **Player Locking**: Prevent accidental name/deck changes
- **Complete Activity Log**: Records all duel actions

## Screenshots

![Duel Interface](https://github.com/user-attachments/assets/85b08959-ebed-4e9b-8f86-2cd2c85b6bbb)
![Card Search](https://github.com/user-attachments/assets/d0a746ab-585f-4c09-a3dd-313952075949)
![Activity Log](https://github.com/user-attachments/assets/9e428986-104c-4498-be59-855e0d42684e)

## Installation

### Option 1: Ready-to-Use EXE (Recommended)
1. Download `YGO_Duel_Tracker.exe` from Releases
2. Run immediately - no dependencies needed

### Option 2: Source Code
1. Install [AutoHotkey v1.1+](https://www.autohotkey.com/)
2. Place `JSON.ahk` in the script directory
3. Create a `\Cache` folder for card images
4. Run `YGO_Duel_Tracker.ahk`

> **Note**: Internet required for card searches. All duel data saves automatically.

## OBS Integration
Display tracker data in OBS:
1. Application saves to text files (`timer.txt`, `lp1.txt`, etc.)
2. In OBS: Add Text Source → Enable "Read from file"
3. Select the corresponding text file
4. Customize font/position as needed

## Version 1.2 Highlights
- New card search functionality
- Improved tabbed interface
- Enhanced tournament features
- Better error handling
- Optimized performance

## Contributing
Suggestions and improvements welcome! Open an issue or PR.

## License
MIT - See [LICENSE](LICENSE)
