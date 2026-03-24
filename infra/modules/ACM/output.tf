output "cert" {
    description = "Cert"
    value = aws_acm_certificate.cert-1
  
}
output "name" {
    description = "domain"
    value = aws_acm_certificate.cert-1.domain_name
  
}
