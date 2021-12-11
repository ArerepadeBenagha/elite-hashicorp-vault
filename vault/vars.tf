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