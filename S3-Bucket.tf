

######################################################
 # Change bucket from "public-read-write" to "private"
######################################################
resource "aws_s3_bucket" "default" {
  bucket = "${var.name}"
  acl = "public-read-write"

  logging {
    target_bucket = "${var.logging_target_bucket}"
    target_prefix = "logs/${var.name}/"
  }
  
######################################################
 # Change Versioning from "false" to "true"
######################################################
  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = "${var.lifecycle_rule_enabled}"
    prefix  = "${var.lifecycle_rule_prefix}"

    transition {
      days          = "${var.standard_ia_transition_days}"
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = "${var.glacier_transition_days}"
      storage_class = "GLACIER"
    }

    expiration {
      days = "${var.expiration_days}"
    }

    noncurrent_version_transition {
      days          = "${var.glacier_noncurrent_version_transition_days}"
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = "${var.noncurrent_version_expiration_days}"
    }
  }

  force_destroy = "${var.force_destroy}"

  tags = "${var.tags}"
}

resource "aws_s3_bucket_policy" "default" {
  bucket = "${aws_s3_bucket.default.id}"
  policy = "${data.aws_iam_policy_document.default.json}"
}

data "aws_iam_policy_document" "default" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      "arn:aws:s3:::${var.name}",
    ]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.name}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control",
      ]
    }

    
  }
}
