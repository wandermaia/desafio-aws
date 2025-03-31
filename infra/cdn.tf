# # Bucket para hospedar o site estático de teste
# resource "aws_s3_bucket" "main" {
#   bucket = "cdn-s3-wms-${var.environment}"
# }

# # Distribuição do cloudfront para o teste com o site estático no bucket
# resource "aws_cloudfront_distribution" "main" {
#   #aliases             = [local.domain]
#   default_root_object = "index.html"
#   enabled             = true
#   is_ipv6_enabled     = true
#   wait_for_deployment = true

#   default_cache_behavior {
#     allowed_methods        = ["GET", "HEAD", "OPTIONS"]
#     cached_methods         = ["GET", "HEAD", "OPTIONS"]
#     cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
#     target_origin_id       = aws_s3_bucket.main.bucket
#     viewer_protocol_policy = "redirect-to-https"
#   }

#   origin {
#     domain_name              = aws_s3_bucket.main.bucket_regional_domain_name
#     origin_access_control_id = aws_cloudfront_origin_access_control.main.id
#     origin_id                = aws_s3_bucket.main.bucket

#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     #acm_certificate_arn      = local.cert_arn
#     # minimum_protocol_version = "TLSv1.2_2021"
#     # ssl_support_method       = "sni-only"
#     cloudfront_default_certificate = true
#   }

#   tags = merge(local.tags, {
#     Name = "cdn-distribution-s3-${var.environment}"
#   })

# }


# resource "aws_cloudfront_origin_access_control" "main" {
#   name                              = "s3-cloudfront-oac"
#   origin_access_control_origin_type = "s3"
#   signing_behavior                  = "always"
#   signing_protocol                  = "sigv4"
# }


# data "aws_iam_policy_document" "cloudfront_oac_access" {
#   statement {
#     principals {
#       type        = "Service"
#       identifiers = ["cloudfront.amazonaws.com"]
#     }

#     actions = [
#       "s3:GetObject"
#     ]

#     resources = ["${aws_s3_bucket.main.arn}/*"]

#     condition {
#       test     = "StringEquals"
#       variable = "AWS:SourceArn"
#       values   = [aws_cloudfront_distribution.main.arn]
#     }
#   }
# }

# resource "aws_s3_bucket_policy" "main" {
#   bucket = aws_s3_bucket.main.id
#   policy = data.aws_iam_policy_document.cloudfront_oac_access.json
# }


# ####################################################################################################


# Configuração da distribuição cdn para o ALB
resource "aws_cloudfront_distribution" "cdn-alb" {

  depends_on = [
    aws_lb.proxy
  ]

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id = aws_cloudfront_cache_policy.cache-control-headers-policy.id
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"
    default_ttl     = "0"

    grpc_config {
      enabled = "false"
    }

    max_ttl                  = "0"
    min_ttl                  = "0"
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
    smooth_streaming         = "false"
    target_origin_id         = aws_lb.proxy.dns_name # "cdn-app-alb-dev-756413770.us-east-1.elb.amazonaws.com"
    viewer_protocol_policy   = "redirect-to-https"
  }

  enabled         = "true"
  http_version    = "http2"
  is_ipv6_enabled = "false"

  origin {
    connection_attempts = "3"
    connection_timeout  = "10"

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_keepalive_timeout = "5"
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = "30"
      origin_ssl_protocols     = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    domain_name = aws_lb.proxy.dns_name # "cdn-app-alb-dev-756413770.us-east-1.elb.amazonaws.com"
    origin_id   = aws_lb.proxy.dns_name # "cdn-app-alb-dev-756413770.us-east-1.elb.amazonaws.com"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"
  staging          = "false"

  viewer_certificate {
    cloudfront_default_certificate = "true"
    minimum_protocol_version       = "TLSv1"
  }

  tags = merge(local.tags, {
    Name = "cdn-distribution-alb-${var.environment}"
  })

}



resource "aws_cloudfront_cache_policy" "cache-control-headers-policy" {
  comment     = "Policy for origins that return Cache-Control headers."
  default_ttl = "0"
  max_ttl     = "31536000"
  min_ttl     = "0"
  name        = "UseOriginCacheControlHeaders"

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "all"
    }

    enable_accept_encoding_brotli = "true"
    enable_accept_encoding_gzip   = "true"

    headers_config {
      header_behavior = "whitelist"

      headers {
        items = ["host", "origin", "x-http-method", "x-http-method-override", "x-method-override"]
      }
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}
