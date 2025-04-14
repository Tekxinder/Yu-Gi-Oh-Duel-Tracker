# YGO Duel Tracker

**YGO Duel Tracker** is an AutoHotkey (AHK) application designed to track duels in the Yu-Gi-Oh! game. It provides an intuitive user interface to manage life points (LP), decks, and victories for players, as well as track duel time.

## Features

- **45-minute Timer**: Built-in timer to track duel time with options to start, pause, and reset.
- **Life Points (LP) Management**: Track LP for two players with options to increase, decrease, or halve LP.
- **Victory Tracking**: Victory counter for each player.
- **Tournament Mode**: Track rounds with options to record wins (W), losses (L), and draws (D).
- **Auto-save**: Automatically save player data to resume duels later.
- **Sound Notifications**: Sound alert when the timer reaches zero.
- **Action Logging**: Record actions in a log for later review.
- **Player Name Locking**: Option to lock player names to prevent accidental changes.

## Screenshots

![Interface YGO Duel tracker](https://github.com/user-attachments/assets/0abc0984-ebb9-4cdb-9d77-bfc974a38d09)

![File YGO Duel tracker](https://github.com/user-attachments/assets/0c44077f-cbbb-4743-9c49-ae56f84756a2)

## Installation

1. **Download AutoHotkey**: Ensure you have AutoHotkey installed on your system. You can download it from the [official website](https://www.autohotkey.com/).

2. **Download the Files**: Download both the `YGO_Duel_Tracker.ahk` and the `YGO_Duel_Tracker.exe` files from this repository.

3. **Run the Application**:
   - If you simply want to use the software, **double-click the `.exe` file** to launch the tracker immediately.
   - If you wish to explore or modify the code, **open the `.ahk` file**, which is the source code of the application. You can edit it with any text editor and run it with AutoHotkey installed.

> **Note:**  
> - The `.ahk` file is the **source code** — use it if you want to modify or inspect the application.
> - The `.exe` file is the **compiled version**, ready to use directly, no installation needed!

## Usage

1. **Launch the Application**: Run the `.exe` file or the `.ahk` script to open the user interface.
2. **Configure Players**: Enter player names, decks, and adjust LP as needed.
3. **Start the Timer**: Click "Start/Pause" to start or pause the timer.
4. **Manage LP and Victories**: Use the buttons to adjust LP and record victories.
5. **Tournament Tracking**: Use tournament options to record match results.

## Setting Up in OBS Studio

To integrate **YGO Duel Tracker** data into OBS Studio using text files, follow these steps:

1. **Prepare Text Files**:
   - Ensure the application saves relevant data (timer, LP, victories) into separate text files (e.g., `timer.txt`, `lp1.txt`, `lp2.txt`).

2. **Create a Text Source in OBS**:
   - Open OBS Studio.
   - Add a new source by clicking the `+` button in the `Sources` section.
   - Select `Text (GDI+)`.

3. **Configure the Text Source**:
   - Name your source (e.g., "Timer").
   - In the text source settings, check `Read from file`.
   - Select the corresponding text file (e.g., `timer.txt`.

4. **Customization**:
   - Customize the text appearance and adjust its position in your OBS scene.

5. **Repeat for Other Data**:
   - Repeat the steps for each piece of data you want to display (LP, victories, etc.).

## Contributions

Contributions are welcome! If you have suggestions or improvements, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
