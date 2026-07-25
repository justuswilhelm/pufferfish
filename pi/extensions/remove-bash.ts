/**
 * Remove Bash Tool Extension
 *
 * Removes the "bash" tool from the set of active tools.
 * This prevents the LLM from executing shell commands.
 *
 * Placement: ~/.pi/agent/extensions/remove-bash.ts (auto-discovered)
 */

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  /**
   * Filter out "bash" from the active tools and apply.
   */
  function applyToolFilter(ctx: ExtensionContext) {
    const allTools = pi.getAllTools();
    const names = allTools.map((t) => t.name);
    const filtered = names.filter((name) => name !== "bash");

    // Only apply if bash was previously active (avoid redundant calls)
    const activeTools = pi.getActiveTools();
    if (!activeTools.includes("bash")) {
      return;
    }

    pi.setActiveTools(filtered);
  }

  // Apply the filter when a session starts
  pi.on("session_start", async (_event, ctx) => {
    applyToolFilter(ctx);
  });

  // Re-apply when navigating the session tree (branch switching)
  pi.on("session_tree", async (_event, ctx) => {
    applyToolFilter(ctx);
  });
}
