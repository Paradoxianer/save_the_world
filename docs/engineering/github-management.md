# 🛠 Development & Workflow Guidelines

## 🏷 GitHub Labels
These are the official labels used in this repository as synchronized with the GitHub CLI.

| Name | Description | Color | Icon |
| :--- | :--- | :--- | :--- |
| `critical` | Kritische Fehler/Blocker | #d73a4a | 🔥 |
| `bug` | Something isn't working | #d73a4a | 🔴 |
| `prio: 0-blocker` | Verhindert den Build oder App-Start | #b60205 | 🛑 |
| `prio: 1-high` | Kritische Logikfehler oder Datenverlust | #d93f0b | 🔥 |
| `prio: 2-medium` | Wichtige UI-Features oder Gameplay-Elemente | #fbca04 | ⚡ |
| `prio: 3-low` | Content-Ausbau und Refactoring | #0e8a16 | ☕ |
| `feature` | New feature request (via enhancement) | #a2eeef | ✨ |
| `enhancement` | New feature or request | #a2eeef | ⚡ |
| `ui` | UI/UX Verbesserungen | #d4c5f9 | 🎨 |
| `balancing` | Spiel-Balance & Wirtschaft | #fef2c0 | ⚖️ |
| `refactor` | Code Refactoring | #e6e6e6 | 🛠 |
| `content` | Gamelogic & Stage Content | #0075ca | 🎮 |
| `documentation` | Improvements or additions to documentation | #0075ca | 📖 |
| `question` | Further information is requested | #d876e3 | ❓ |
| `help wanted` | Extra attention is needed | #008672 | 🙋‍♂️ |
| `good first issue` | Good for newcomers | #7057ff | 👶 |
| `invalid` | This doesn't seem right | #e4e669 | 🚫 |
| `duplicate` | This issue or pull request already exists | #cfd3d7 | 👯 |
| `wontfix` | This will not be worked on | #ffffff | 🙅 |

## 🏁 Milestones (Release Cycles)
To list all milestones via CLI, use the GitHub API:
`gh api repos/Paradoxianer/save_the_world/milestones --jq ".[] | {title: .title, number: .number, state: .state}"`

| ID | Title | Strategic Goal |
| :--- | :--- | :--- |
| **1** | **Release 1 (R1)** | **Visual Polish, Bugfixes and Store Readiness** |
| **2** | **Release 2 (R2)** | **Internationalization, Firebase and Audio Engine** |

## 🛠 Useful Commands
- `.\scripts\init_store_metadata.ps1`: Syncs Android & iOS metadata.
- `fastlane supply init`: Fetch metadata from Google Play.
- `gh issue list --milestone 1`: List all issues for Release 1.
- `gh issue list --milestone 2`: List all issues for Release 2.
- `gh issue create --title "..." --label "enhancement" --milestone "Release 1 (R1)"`: Create new issue.
