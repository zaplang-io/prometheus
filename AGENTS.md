# prometheus workspace conventions (zaplang-io/prometheus)

This is an official non-core Zap module. Target: parity with the popular Python
equivalent ([`prometheus_client`](https://github.com/prometheus/client_python)),
with the [Prometheus exposition format](https://prometheus.io/docs/instrumenting/exposition_formats/)
and [OpenMetrics](https://github.com/prometheus/OpenMetrics) specifications as the
wire-format authority.

## Language-first (non-negotiable)
- All language or stdlib bugs discovered while building this module MUST be reported in `zaplang-io/zap` FIRST, and no workaround is permitted. Keep the dependent work blocked or draft and report the dependency; never build the library around a core defect.

## Python parity & signatures
- Match the `prometheus_client` API surface and naming (`CollectorRegistry`, `Counter`, `Gauge`, `.labels(...)`, `generate_latest`, `start_http_server`, …) as closely as the language allows.
- Where a function/method signature is ambiguous or there is any confusion about argument shape, defaults, or keyword-vs-positional, do NOT just pick one: present the options to the maintainer with concrete examples of what `prometheus_client` does, and let the maintainer decide. Record the chosen design in `DECISIONS.md`.
- The exposition bytes are normative: they MUST validate against a real Prometheus/OpenMetrics parser, not merely look plausible.

## Tests
- All test cases live in the `tests/` folder and use the `zap test` methodology (`zap test tests/`).
- Every PR MUST include extensive positive AND negative test cases — treat tests as a walled garden and as intent documentation, not a minimal smoke check. Cover edge cases, error paths, malformed metric/label names, and exposition-format escaping.
- When fixing a bug, write the failing test first, then fix.

## CI
- CI runs against `ghcr.io/zaplang-io/zap:latest` and MUST continue to pin `zap:latest` until this module reaches a proper major (1.0) version release; only then pin a released toolchain version.

## Issues & PRs
- Keep issues concrete and testable with detailed bodies (repro or intended syntax, `prometheus_client` equivalent, references).
- Multi-issue features get an Epic with trackable sub-issues. Individual issues are 'M' sized.
- One issue, one PR. Rebase onto the latest default branch before raising or updating a PR.
- Documentation (README, DECISIONS.md, CHANGELOG) stays current with every PR.
