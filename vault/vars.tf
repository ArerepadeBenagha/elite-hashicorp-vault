variable "instance_type" {
  type        = string
  description = "instance size for ec2"
}
variable "datadog_api_key" {
  type = string
}
variable "datadog_app_key" {
  type = string
}

# Variable defining the query and threshold shared by a monitor and graph for the CPU usage.
variable "cpu_usage" {
  type = map(string)

  default = {
    query     = "avg:aws.ec2.cpuutilization"
    threshold = "85"
  }
}
variable "trigger_by" {
  default = "{host,env}"
}
variable "bucket_name" {
  type = string
}
variable "domain_name" {
  type = string
}