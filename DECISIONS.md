# prometheus package decisions

Design decisions for the Zap `prometheus` library, keyed to issues. Each records a
choice that could not be read straight off Python's
[prometheus_client](https://github.com/prometheus/client_python), with the
reference it follows or departs from. Signature ambiguities are resolved with the
maintainer (with `prometheus_client` examples) before being recorded here.

## Parity target: prometheus_client

The package tracks [**prometheus_client**](https://github.com/prometheus/client_python)
as its primary API reference. The
[Prometheus exposition format](https://prometheus.io/docs/instrumenting/exposition_formats/)
and the [OpenMetrics specification](https://github.com/prometheus/OpenMetrics/blob/main/specification/OpenMetrics.md)
are the authority for the wire output and the tie-breaker when the Python client
and the spec differ. Deviations are recorded below, keyed to the issue that
introduces them.

<!-- Decisions are appended per issue as the first slice lands (see the epic). -->
