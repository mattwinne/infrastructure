data "aws_acm_certificate" "pollinone" {
  domain      = "pollinone.xyz" #includes www.pollinone.xyz and data.pollinone.xyz
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_acm_certificate" "api-pollinone" {
  domain      = "api.pollinone.xyz"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}