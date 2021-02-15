const builtin = @import("builtin");
const std = @import("std");
const Builder = std.build.Builder;
const Pkg = std.build.Pkg;
const Mode = builtin.Mode;

const EXAMPLES = [_][]const u8{
    "line_chart",
};

const cairo_pkg = Pkg{ .name = "cairo", .path = "packages/zig-cairo/src/cairo.zig" };

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const test_all_modes_step = b.step("test", "Run all tests in all modes");
    inline for ([_]Mode{ Mode.Debug, Mode.ReleaseFast, Mode.ReleaseSafe, Mode.ReleaseSmall }) |test_mode| {
        const mode_str = comptime modeToString(test_mode);
        const name = "test-" ++ mode_str;
        const desc = "Run all tests in " ++ mode_str ++ " mode";
        const tests = b.addTest("src/charts.zig");
        tests.setBuildMode(mode);
        tests.setTarget(target);
        tests.setNamePrefix(mode_str ++ " ");
        tests.linkLibC();
        tests.linkSystemLibrary("xcb");
        tests.linkSystemLibrary("pangocairo");
        tests.addPackage(cairo_pkg);
        const test_step = b.step(name, desc);
        test_step.dependOn(&tests.step);
        test_all_modes_step.dependOn(test_step);
    }

    inline for (EXAMPLES) |name| {
        const example = b.addExecutable(name, "examples" ++ std.fs.path.sep_str ++ name ++ ".zig");
        example.linkLibC();
        example.linkSystemLibrary("xcb");
        example.linkSystemLibrary("pangocairo");
        example.addPackage(cairo_pkg);
        const charts_deps = [_]Pkg{
            cairo_pkg,
        };
        const charts_pkg = Pkg{ .name = "charts", .path = "src/charts.zig", .dependencies = &charts_deps };
        example.addPackage(charts_pkg);
        example.setBuildMode(mode);
        example.setTarget(target);

        const run_cmd = example.run();
        run_cmd.step.dependOn(b.getInstallStep());
        const desc = "Run " ++ name ++ " example";
        const run_step = b.step(name, desc);
        run_step.dependOn(&run_cmd.step);
    }
}

fn modeToString(mode: Mode) []const u8 {
    return switch (mode) {
        Mode.Debug => "debug",
        Mode.ReleaseFast => "release-fast",
        Mode.ReleaseSafe => "release-safe",
        Mode.ReleaseSmall => "release-small",
    };
}
