// SPDX-FileCopyrightText: 2026 Justus Perlwitz
// SPDX-License-Identifier: GPL-3.0-or-later

// Check that tool calls can't read outside of the context cwd
// Block any tool calls for which this extension can't verify the path

import type { ExtensionAPI, ExtensionContext, ToolCallEvent } from "@earendil-works/pi-coding-agent";
import path from "node:path";
import fs from "node:fs/promises";

export default function (pi: ExtensionAPI) {
  // pi defines 6 core tools (including bash, which we block in another
  // extension)
  // See the `ToolSoptions` interface here:
  // export interface ToolsOptions {
  //  read?: ReadToolOptions;
  //  bash?: BashToolOptions;
  //  write?: WriteToolOptions;
  //  edit?: EditToolOptions;
  //  grep?: GrepToolOptions;
  //  find?: FindToolOptions;
  //  ls?: LsToolOptions;
  // }
  // https://github.com/earendil-works/pi/blob/e47b8e37a6211ebd0b2942fa87059d64f81eec02/packages/coding-agent/src/core/tools/index.ts#L86
  const allowList = [
    // readSchema has property 'path':
    // > path: Type.String({ description: "Path to the file to read (relative or absolute)" }),
    // https://github.com/earendil-works/pi/blob/e47b8e37a6211ebd0b2942fa87059d64f81eec02/packages/coding-agent/src/core/tools/read.ts#L21
    "read",
    // writeSchema has property 'path':
    // > path: Type.String({ description: "Path to the file to write (relative or absolute)" }),
    // https://github.com/earendil-works/pi/blob/e47b8e37a6211ebd0b2942fa87059d64f81eec02/packages/coding-agent/src/core/tools/write.ts#L15
    "write",
    // editSchema has property 'path'
    // > path: Type.String({ description: "Path to the file to edit (relative or absolute)" }),
    // https://github.com/earendil-works/pi/blob/e47b8e37a6211ebd0b2942fa87059d64f81eec02/packages/coding-agent/src/core/tools/edit.ts#L44
    "edit",
    // grepSchema has property 'path'
    // > path: Type.Optional(Type.String({ description: "Directory or file to search (default: current directory)" })),
    // https://github.com/earendil-works/pi/blob/e47b8e37a6211ebd0b2942fa87059d64f81eec02/packages/coding-agent/src/core/tools/grep.ts#L26
    "grep",
    // findSchema has property 'path'
    // > path: Type.Optional(Type.String({ description: "Directory to search in (default: current directory)" })),
    // https://github.com/earendil-works/pi/blob/e47b8e37a6211ebd0b2942fa87059d64f81eec02/packages/coding-agent/src/core/tools/find.ts#L33
    "find",
    // lsSchema has property 'path'
    // > path: Type.Optional(Type.String({ description: "Directory to list (default: current directory)" })),
    // https://github.com/earendil-works/pi/blob/e47b8e37a6211ebd0b2942fa87059d64f81eec02/packages/coding-agent/src/core/tools/ls.ts#L15
    "ls",
  ];

  pi.on("tool_call", async (event: ToolCallEvent, ctx: ExtensionContext) => {
    // Check our allowList for the event's tool name.
    const { toolName } = event;
    if (!allowList.includes(toolName)) {
      return {
        block: true,
        reason: `Access denied. You can't use "${toolName}" because pi can't verify that it uses safe paths. Consider adding this tool name to the 'path-isolation' extension`,
        // TODO look up what terminate?: boolean does
      };
    }

    const { cwd } = ctx;
    // Check if cwd is "", undefined, or null
    // For reference:
    // > !("")
    // true
    // > !(undefined)
    // true
    // > !(null)
    // true
    // > !("a")
    // false
    // > !({})
    // false
    if (!cwd) {
      throw new Error("cwd is empty. Why?")
    }

    // Check that the context cwd and process cwd match. Why shouldn't they?
    // I don't know, and I don't want to know
    if (cwd !== process.cwd()) {
      throw new Error("Extension context cwd and process.cwd() do not match. Why?");
    }

    const { path: target } = event.input;
    // Also, check if cwd is "", undefined, or null
    if (!target) {
      throw new Error("Couldn't find path property in event.");
    }
    if (target === "") {
      return {
        block: true,
        reason: "Access denied. You've passed an empty path.",
      };
    }

    // Calculate the path of `target` relativ to the context cwd
    // For reference:
    // > const path = await import("node:path")
    // > process.cwd()
    // '/home/debian/.dotfiles'
    // > path.relative(process.cwd(), "foo")
    // 'foo'
    // > path.relative(process.cwd(), "/foo")
    // '../../../foo'
    // > path.relative(process.cwd(), path.join(process.cwd(), "../.config"))
    // '../bar'
    const resolved_path = path.relative(cwd, target);
    // Path starts with ".."? Outside of cwd
    if (resolved_path.startsWith("..")) {
      return {
        block: true,
        reason: `Access denied. Path "${target}" must be a path within the current working directory "${cwd}".`,
      };
    }

    // Check if the path is a directory or regular file
    // See definition of isFile() and isDirectory()
    // https://nodejs.org/api/fs.html#statsisfile
    // https://nodejs.org/api/fs.html#statsisdirectory
    // block if not file or directory
    const stats = await fs.stat(resolved_path);
    if (stats.isFile()) {
      return {
        block: false,
        reason: `Access granted. Path "${target}" is a regular file.`,
      };
    } else if (stats.isDirectory()) {
      return {
        block: false,
        reason: `Access granted. Path "${target}" is a directory.`,
      };
    } else {
      return {
        block: true,
        reason: `Access denied. Path "${target}" is neither a regular file nor directory.`,
      };
    }
  });
}
