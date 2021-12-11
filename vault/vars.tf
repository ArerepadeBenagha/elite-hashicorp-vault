variable "instance_type" {
  type        = string
  description = "instance size for ec2"
}
variable "datadog_api_key" {
  default = string
}
variable "datadog_app_key" {
  default = string
}