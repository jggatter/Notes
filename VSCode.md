## Hotkeys

### Code Editor

Cmd + Shift + P: Command palette
Cmd + P: File search
Cmd + \`: Toggle integrated terminal
Cmd + Shift + \`: Create a new terminal
Cmd + Option + H: Open call hierarchy

Cmd + Option + Left/Right arrow keys: Navigate left/right through tabs
Cmd + Shift + E: Toggle/focus on the sidebar versus editor
- up + down to navigate files
- space to open file/folder
- or enter to rename file

Cmd + Shift + T: Reopen last closed file
Cmd + N: Open new file
Cmd + W: Close file

Cmd + /: Toggle line comment

F2: Rename symbol under cursor within file
Cmd + F2: Rename symbol under cursor across files

### Jupyter Notebook

#### Navigation:
Up / down: scrolls
Enter / Esc: Enter or exit editing mode

#### Cell management:
Option + up/down: Move selected cell up and down
A / B: Insert a new cell below or above selected cell
X: Delete cell
Z: Undo
Y / M / R: Change cell type to code / markdown/ raw.
#### Editing mode:

## Settings

editor.cursorSurroundingLines: As cursor scrolls keep the surrounding number of leading and trailing lines visible. A large enough number like 100 will the cursor always in the center. A smaller number like 20 allows for some straying from the center without scrolling.

## Command Palette

Opens with `>` character by default to help you select a key. If you delete this though, you can perform searches for files! Same as Cmd + P

## Debugger

### Python - Remote Attach

When working working directly on the remote system using Remote - SSH, the default configuration (`"remoteRoot": ".")` is for attaching to a debug server that expects the code to be running locally and trying to map to a remote location, which is unnecessary and confusing for this direct setup.

So, make sure to set localRoot equal to remoteRoot:
```json
{
    "configurations": [
        {
            "name": "Python: Remote Attach",
            "type": "debugpy",
            "request": "attach",
            "connect": {
                "host": "localhost",
                "port": 5678
            },
            "justMyCode": false,
            "pathMappings": [
                {
                    "localRoot": "${workspaceFolder}",
                    "remoteRoot": "${workspaceFolder}"
                }
            ]
        }
    ]
}
```
Run this then immediately trigger the debug attachment in VS Code.
```sh
python -m debugpy --listen 5678 myscript.py <args>
```
### Python: Launch

This is probably simpler than remote attach.
```json
{
    "name": "Python: Remote Debug",
    "type": "python",
    "request": "launch",
    "program": "${workspaceFolder}/myscript.py",
    "console": "integratedTerminal",
    "justMyCode": false
}

```