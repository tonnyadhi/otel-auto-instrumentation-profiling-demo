# go-otel-auto-prof-demo

A demo Go HTTP service with:
- **Pyroscope continuous profiling**, with trace/profile ID correlation
- **OpenTelemetry auto-instrumentation (eBPF/Go Auto Agent)** for distributed tracing
- **Docker Compose** for all services (app, Pyroscope, OTel Collector, Jaeger)

## How to Run

1. **Run the stack setup script**  
   The provided script will clone the OTel Go auto-instrumentation agent and start the full stack for you.
   ```sh
   ./otel_stack.sh
   ```

   > If you haven't already, make the script executable with:
   > ```sh
   > chmod +x otel_stack.sh
   > ```

2. **Main Endpoints:**
   - [http://localhost:8080/hello](http://localhost:8080/hello)
   - [http://localhost:8080/work](http://localhost:8080/work)

3. **View traces:**  
   Jaeger UI: [http://localhost:16686](http://localhost:16686)

4. **View profiles:**  
   Pyroscope UI: [http://localhost:4040](http://localhost:4040)

## Architecture

- **app**: The demo Go HTTP service, with Pyroscope Go SDK for profiling and OTel API for span correlation.
- **go-auto**: The OpenTelemetry Go Auto Instrumentation (eBPF agent) container, which observes the app for traces and CPU profiles, exporting them via OTLP to the Collector.
- **otel-collector**: Receives traces/profiles via OTLP and forwards traces to Jaeger.
- **jaeger**: Trace backend.
- **pyroscope**: Profile backend.

## Trace/Profile Correlation

- All profiles are tagged with the current active trace and span IDs.
- In Grafana/Pyroscope, you can jump between traces and profiles via trace/span ID.

## Notes

- **Pyroscope exporter in OTel Collector**: The official otel/opentelemetry-collector-contrib image does _not_ support the Pyroscope exporter out of the box. Profile data is sent directly from the Go app to Pyroscope using the Pyroscope Go SDK.
- **Traces**: Are sent from the Go Auto agent to the OTel Collector and then to Jaeger via OTLP.

## References

- [Pyroscope Go Trace Correlation Guide](https://grafana.com/docs/pyroscope/latest/trace-correlation/go/)
- [OpenTelemetry Go Instrumentation](https://github.com/open-telemetry/opentelemetry-go-instrumentation)
- [Pyroscope Docker integration](https://pyroscope.io/docs/docker/)

