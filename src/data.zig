const std = @import("std");
const testing = std.testing;
const log = std.log;

const sql = @cImport(@cInclude("sqlite3.h"));

pub const PersistentStorage = struct {
    const Self = @This();

    const Error = error{
        BAD_CONNECTION,
        FAILED_PING,
    };

    _client: *sql.sqlite3,

    pub fn open(path: []const u8) Error!Self {
        var client: ?*sql.sqlite3 = null;
        if (sql.sqlite3_open(path.ptr, &client) != sql.SQLITE_OK) {
            log.err("failed to connection to db: {s}", .{sql.sqlite3_errmsg(client)});
            return Error.BAD_CONNECTION;
        }

        return Self{
            ._client = client.?,
        };
    }

    pub fn close(self: *const Self) void {
        if (sql.sqlite3_close(self._client) != sql.SQLITE_OK) {
            log.err("failed to close connection to db: {s}", .{sql.sqlite3_errmsg(self._client)});
        }
    }

    pub fn check(self: *const Self) Error!void {
        const query = "SELECT 1";
        var errmsg: [*c]u8 = null;

        if (sql.sqlite3_exec(self._client, query, null, null, &errmsg) != sql.SQLITE_OK) {
            log.err("failed to check db", .{});
            return Error.FAILED_PING;
        }

        return;
    }
};

test "persistent-storage: open and close" {
    try std.fs.cwd().makeDir("./tmp");
    defer std.fs.cwd().deleteTree("./tmp") catch unreachable;

    const store = try PersistentStorage.open("./tmp/store.data");
    defer store.close();

    try store.check();
}
