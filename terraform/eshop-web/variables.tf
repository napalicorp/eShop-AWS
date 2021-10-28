variable "env_prefix" {
  description = "Name of the environment"
  type        = string
  default     = "stg"
}

variable "build_number" {
  description = "Build number to tag the image"
  type        = string
  default     = "latest"
}