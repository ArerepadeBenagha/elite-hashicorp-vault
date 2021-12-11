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
  provider           = datadog.datadog_dev

  query = "avg(last_5m):${var.cpu_usage["query"]}{*} by ${var.trigger_by} > ${var.cpu_usage["threshold"]}"

  monitor_thresholds {
    warning           = 50
    warning_recovery  = 85
    critical          = 85
    critical_recovery = 50
  }

  notify_no_data    = true
  renotify_interval = 60

  notify_audit = false
  timeout_h    = 60
  include_tags = true

  tags = ["Application:vault-server", "datadog"]
}