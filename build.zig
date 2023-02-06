const std = @import("std");

const build_pkgs = @import("deps.zig").build_pkgs;

const libgit2 = @import("libgit2.zig");
const mbedtls = build_pkgs.mbedtls;
const libssh2 = build_pkgs.libssh2;
const zlib = build_pkgs.zlib;

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const z = zlib.create(b, target, optimize);
    const tls = mbedtls.create(b, target, optimize);
    const ssh2 = libssh2.create(b, target, optimize);
    tls.link(ssh2.step);

    const git2 = try libgit2.create(b, target, optimize);
    ssh2.link(git2.step);
    tls.link(git2.step);
    z.link(git2.step, .{});
    git2.step.install();

    const test_step = b.step("test", "Run tests");
    _ = test_step;
}
