const std = @import("std");
const log = std.log;

const sqlfs = @import("root.zig");

pub fn main() void {
    log.info("sqlfs version {s}", .{sqlfs.version()});
}
