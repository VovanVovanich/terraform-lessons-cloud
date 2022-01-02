variable "server_name" {
  description = "Name for WebServer"
  type = string
  default = "demo"
}

variable "server_size" {
  description = "Server Size for WebServer"
  type = string
  default = "t3.micro"
}

/* you should make these enviroment variables in 
terraform cloud:
AWS_ACCESS_KEY_ID  - make it sensitive
AWS_SECRET_ACCESS_KEY  - make it sensitive
AWS_DEFAULT_REGION
*/
