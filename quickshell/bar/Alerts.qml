pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

// Workspaces with a terminal bell the user hasn't looked at yet. Hyprland
// sends `bell>>ADDRESS` for it, not `urgent`, so the toplevel's urgent flag
// stays off. Shared by all bars; a mark clears when its workspace gets
// focus, goes away, or the window that rang closes.
Singleton {
    id: root

    // Workspace id (1-10) -> address of the window that rang
    property var belled: ({})

    // Address that wasn't in the toplevel list yet, retried once after a refresh
    property string pending: ""

    readonly property int focusedId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 0

    onFocusedIdChanged: {
        if (belled[focusedId] === undefined)
            return;
        const next = Object.assign({}, belled);
        delete next[focusedId];
        belled = next;
    }

    // Hyprland's addresses may or may not carry "0x"
    function bare(address) {
        return address.toLowerCase().replace(/^0x/, "");
    }

    // Returns false if the window isn't known yet
    function mark(address) {
        const toplevel = Hyprland.toplevels.values.find(t => bare(t.address) === address);
        if (!toplevel || !toplevel.workspace)
            return false;
        const ws = toplevel.workspace;
        // Already on screen on some monitor, nothing to point at
        if (ws.id < 1 || ws.id > 10 || ws.active)
            return true;
        const next = Object.assign({}, belled);
        next[ws.id] = address;
        belled = next;
        return true;
    }

    // Keeps only marks whose workspace and window still exist
    function prune() {
        const ids = Hyprland.workspaces.values.map(ws => ws.id);
        const addresses = Hyprland.toplevels.values.map(t => bare(t.address));
        const next = {};
        let changed = false;
        for (const id in belled) {
            if (ids.includes(Number(id)) && addresses.includes(belled[id]))
                next[id] = belled[id];
            else
                changed = true;
        }
        if (changed)
            belled = next;
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name !== "bell")
                return;
            const address = root.bare(event.data);
            if (!root.mark(address) && root.pending !== address) {
                root.pending = address;
                Hyprland.refreshToplevels();
            }
        }
    }

    Connections {
        target: Hyprland.toplevels

        function onValuesChanged() {
            if (root.pending !== "") {
                root.mark(root.pending);
                root.pending = "";
            }
            root.prune();
        }
    }

    Connections {
        target: Hyprland.workspaces

        function onValuesChanged() {
            root.prune();
        }
    }
}
