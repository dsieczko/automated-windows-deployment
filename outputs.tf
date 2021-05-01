output "public_ipv4" {
  description = "Public IPv4 address of the Windows server"
  value       = metal_device.windows_server.access_public_ipv4
}
