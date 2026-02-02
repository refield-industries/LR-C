const std = @import("std");
const windows = std.os.windows;

const Io = std.Io;

extern "kernel32" fn VirtualProtect(
    ?*anyopaque,
    windows.SIZE_T,
    windows.PAGE,
    *windows.PAGE,
) callconv(.winapi) void;

pub fn replace(address: usize, comptime replacement: anytype) void {
    const trampoline_size: usize = 12;
    const replacement_address = &replacement;

    var permissions: windows.PAGE = .{ .EXECUTE_READWRITE = true };
    VirtualProtect(@ptrFromInt(address), trampoline_size, permissions, &permissions);

    const location: [*]u8 = @ptrFromInt(address);
    var writer: Io.Writer = .fixed(location[0..12]);
    writer.writeAll(&.{ 0x48, 0xB8 }) catch unreachable; // mov ${}, %rax
    writer.writeInt(u64, @intFromPtr(replacement_address), .little) catch unreachable; // ${}
    writer.writeAll(&.{ 0x50, 0xC3 }) catch unreachable; // push %rax; ret

    VirtualProtect(@ptrFromInt(address), trampoline_size, permissions, &permissions);
}

pub fn write(address: usize, data: []const u8) void {
    var permissions: windows.PAGE = .{ .EXECUTE_READWRITE = true };
    VirtualProtect(@ptrFromInt(address), data.len, permissions, &permissions);
    const location: [*]u8 = @ptrFromInt(address);
    @memcpy(location[0..data.len], data);
    VirtualProtect(@ptrFromInt(address), data.len, permissions, &permissions);
}
