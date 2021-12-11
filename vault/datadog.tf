# # Monitor for the the CPU usage.
# resource "datadog_monitor" "cpu_usage" {
#   name           = "CPU usage high"
#   query          = "avg(last_5m):${var.cpu_usage["query"]}{*} by ${var.trigger_by} > ${var.cpu_usage["threshold"]}"
#   type           = "query alert"
#   notify_no_data = true
#   include_tags   = true

#   message = <<EOM
# CPU usage high: {{value}}
# ${var.datadog_alert_footer}
# EOM
# }

# Create a new Datadog monitor
resource "datadog_monitor" "elitedatadog" {
  name               = "elitedatadog"
  type               = "metric alert"
  message            = "Monitor triggered. Notify: @hipchat-channel"
  escalation_message = "Escalation message @pagerduty"

  query = "avg(last_5m):${var.cpu_usage["query"]}{*} by ${var.trigger_by} > ${var.cpu_usage["threshold"]}"

  monitor_thresholds {
    warning           = 2
    warning_recovery  = 1
    critical          = 4
    critical_recovery = 3
  }

  notify_no_data    = false
  renotify_interval = 60

  notify_audit = false
  timeout_h    = 60
  include_tags = true

  tags = merge(local.common_tags,
    { Name = "datadog monitor"
  Application = "public" })
}