# prometheus

Prometheus metrics client for [Zap](https://github.com/zaplang-io/zap) — an official **non-core** package.

- Tracking issue: [zaplang-io/zap#330](https://github.com/zaplang-io/zap/issues/330)
- Contributor & agent conventions: [AGENTS.md](AGENTS.md)
- Design decisions: [DECISIONS.md](DECISIONS.md)

Instrument a Zap service and expose its metrics in the Prometheus text format over an HTTP `/metrics` endpoint. The [Tier-1 epic](https://github.com/zaplang-io/prometheus/issues/1) tracks the metric types, exposition format, and HTTP server.

## Goals

A typed Zap metrics client whose public API mirrors Python's [**prometheus_client**](https://github.com/prometheus/client_python) as closely as Zap's static typing allows. API-parity with the popular Python library is a project rule — see [AGENTS.md](AGENTS.md). The wire output conforms to the [Prometheus exposition format](https://prometheus.io/docs/instrumenting/exposition_formats/) and [OpenMetrics](https://github.com/prometheus/OpenMetrics/blob/main/specification/OpenMetrics.md).

Planned scope (first cut):

- **Collector registry** — `CollectorRegistry` plus a process-wide default registry that metrics attach to automatically.
- **Core metric types** — `Counter` (monotonic) and `Gauge` (up/down), with label dimensions via `.labels(...)`.
- **Text exposition** — `generate_latest(registry)` renders the registry to the Prometheus/OpenMetrics text format, with `CONTENT_TYPE_LATEST`.
- **HTTP exposition** — `start_http_server(port, ...)` serves `/metrics` for a Prometheus scraper.

Deferred to later issues (named in the [epic](https://github.com/zaplang-io/prometheus/issues/1), not in the first slice):

- **`Histogram` and `Summary`** — bucketed observations and quantiles.
- **`Info` and `Enum`** metric types.
- **Multiprocess mode** — aggregating metrics across worker processes.
- **Pushgateway** — `push_to_gateway` for batch/ephemeral jobs.
- **WSGI/ASGI adapters** and framework integrations.

## Planned usage

```zap
import prometheus

# Counter with no labels, registered on the default registry.
requests = prometheus.Counter("http_requests_total", "Total HTTP requests")
requests.inc()
requests.inc(by=2.0)

# Gauge with label dimensions.
in_progress = prometheus.Gauge(
    "http_requests_in_progress",
    "In-flight HTTP requests",
    labelnames=["method", "path"],
)
in_progress.labels(method="GET", path="/").inc()
in_progress.labels(method="GET", path="/").dec()

# Render the default registry to the Prometheus text format.
body = prometheus.generate_latest()
print(body)

# Serve /metrics for a scraper.
prometheus.start_http_server(8000)
```

The exact signatures (keyword vs positional, defaults, return shapes) are not final. Any ambiguity is escalated to the maintainer with `prometheus_client` examples and recorded in [DECISIONS.md](DECISIONS.md) rather than decided unilaterally.

## Build and test

Run the native `zap test` suite against a temporary consumer that installs this
checkout as a package:

```
sh tools/test.sh
```

GitHub Actions runs the suite on pull requests and pushes inside the
`ghcr.io/zaplang-io/zap:latest` container. CI stays pinned to `zap:latest`
until this module reaches a 1.0 release.

## Development

Read **[AGENTS.md](AGENTS.md)** before contributing — it covers the `prometheus_client`-parity rule, the one-issue-one-PR flow, how design decisions are recorded in **[DECISIONS.md](DECISIONS.md)**, and the rule for reporting core Zap language/stdlib defects upstream in `zaplang-io/zap` (rather than working around them here).
