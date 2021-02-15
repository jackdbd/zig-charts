# zig-charts

TODO

## Examples

Run `zig build --help` to see all the compilation targets.

Most examples generate a PNG. Here I use [feh](https://feh.finalrewind.org/) to view the generated file:

```sh
zig build line_chart && feh examples/generated/line_chart.png
```

## Tests

```sh
# run all tests, in all modes (debug, release-fast, release-safe, release-small)
zig build test

# run all tests, only in debug mode
zig build test-debug
```
