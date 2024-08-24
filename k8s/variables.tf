variable "ssh_key" {
  default = "ssh"
}
variable "proxmox_host" {
    default = "tags-p51"
}
variable "template_name" {
    default = "debian-20240717-cloudinit-template"
}
variable "pm_api_url" {
    default = "https://127.0.0.1:8006/api2/json"
}
variable "pm_api_token_id" {
    default = "user@pam!token"
}
variable "pm_api_token_secret" {
    default = "secret-api-token"
}
variable "k8s_config_path" {
    default = "/etc/kubernetes/admin.yaml"
}
variable "k8s_namespace_state" {
    default = "default"
}

