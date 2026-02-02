const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(
        .{ .default_target = .{ .os_tag = .windows } },
    );

    const dll = b.addLibrary(.{
        .name = "gfsdk",
        .linkage = .dynamic,
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    b.installArtifact(dll);
}
