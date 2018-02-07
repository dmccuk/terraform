variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "eu-west-1"
}
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 80
}
