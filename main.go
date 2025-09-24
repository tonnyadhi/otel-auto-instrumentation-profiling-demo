package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/grafana/pyroscope-go"
	"go.opentelemetry.io/otel"
)

func main() {
	_, err := pyroscope.Start(pyroscope.Config{
		ApplicationName: "go-otel-auto-prof-demo",
		ServerAddress:   "http://pyroscope:4040",
		Logger:          pyroscope.StandardLogger,
	})
	if err != nil {
		log.Fatalf("failed to start pyroscope profiler: %v", err)
	}

	tracer := otel.Tracer("go-otel-auto-prof-demo")

	http.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
		ctx, span := tracer.Start(r.Context(), "hello-handler")
		defer span.End()
		traceID := span.SpanContext().TraceID().String()
		spanID := span.SpanContext().SpanID().String()

		pyroscope.TagWrapper(
			ctx,
			pyroscope.Labels("trace_id", traceID, "span_id", spanID),
			func(ctx context.Context) {
				fmt.Fprintf(w, "Hello from Go with Pyroscope profiling and OTel traces!\n")
			},
		)
	})

	http.HandleFunc("/work", func(w http.ResponseWriter, r *http.Request) {
		ctx, span := tracer.Start(r.Context(), "work-handler")
		defer span.End()
		traceID := span.SpanContext().TraceID().String()
		spanID := span.SpanContext().SpanID().String()

		pyroscope.TagWrapper(
			ctx,
			pyroscope.Labels("trace_id", traceID, "span_id", spanID),
			func(ctx context.Context) {
				for i := 0; i < 5; i++ {
					time.Sleep(200 * time.Millisecond)
				}
				fmt.Fprintf(w, "Simulated work done!\n")
			},
		)
	})

	log.Println("Listening on :8080 ...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
