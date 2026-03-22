const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(
        .{ .default_target = .{ .os_tag = .windows } },
    );

    const versions = [_]struct { []const u8, []const u8 }{
        .{ "gfsdk", "src/proxy_exports.zig" },
        .{ "hgsdk", "src/proxy_exports_cn.zig" }
    };

    inline for (versions) |ver| {
        const dll = b.addLibrary(.{
            .name = ver[0],
            .linkage = .dynamic,
            .root_module = b.createModule(.{
                .root_source_file = b.path("src/root.zig"),
                .target = target,
                .optimize = optimize,
            }),
        });

        dll.root_module.addImport("proxy_exports.zig", b.createModule(.{
            .root_source_file = b.path(ver[1]),
            .target = target,
            .optimize = optimize,
        }));

        b.installArtifact(dll);
    }
}
