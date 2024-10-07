const std = @import("std");
const testing = std.testing;

pub const Storage = @import("storage.zig");

pub fn version() []const u8 {
    return "0.1.0";
}

test "check version" {
    try testing.expectEqual(version(), "0.1.0");
}

test {
    std.testing.refAllDecls(@This());
}
