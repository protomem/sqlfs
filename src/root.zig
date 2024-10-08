const std = @import("std");
const testing = std.testing;

pub const data = @import("data.zig");
pub const fuse = @import("fuse.zig");

pub fn version() []const u8 {
    return "0.1.0";
}

test "check version" {
    try testing.expectEqual(version(), "0.1.0");
}

test "fuse: check version" {
    try testing.expect(fuse.FUSE_USE_VERSION >= 31);
}

test {
    testing.refAllDecls(@This());
}
