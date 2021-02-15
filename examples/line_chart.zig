const std = @import("std");
const charts = @import("charts");

pub fn main() !void {
    var cfg = charts.Config{ .outer_width = 1280, .outer_height = 720 };
    var points = [_]charts.Point{
        .{ .x = 0, .y = 85 },
        .{ .x = 50, .y = 35 },
        .{ .x = 75, .y = 75 },
        .{ .x = 100, .y = 10 },
        .{ .x = 115, .y = 0 },
        .{ .x = 160, .y = 190 },
        .{ .x = 200, .y = 85 },
    };
    var chart = try charts.lineChart(cfg);
    defer chart.destroy();

    try chart.draw(&points);
    try chart.writeToPng("examples/generated/line_chart.png");
}
