resource "aws_codebuild_project" "myapp" {
  name           = local.codebuild_project
  description    = local.codebuild_project
  build_timeout  = 5
  queued_timeout = 10
  service_role   = aws_iam_role.myapp.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = local.source_location
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
    report_build_status = true
  }


  vpc_config {
    vpc_id = local.vpc_id

    subnets = [
      local.private_subnet_1_id,
    ]

    security_group_ids = [
      aws_security_group.codebuild_allow_tls.id,
    ]
  }
  tags = local.tags
}


resource "aws_codebuild_webhook" "myapp" {
  project_name = aws_codebuild_project.myapp.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "WORKFLOW_JOB_QUEUED"
    }
  }
}

#IAM
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "myapp" {
  name               = "codebuild_myapp_${local.app_env}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "myapp" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterfacePermission"
    ]
    resources = ["arn:aws:ec2:eu-west-1:${local.account_id}:network-interface/*"]
    condition {
      test     = "StringEquals"
      variable = "ec2:Subnet"
      values   = ["arn:aws:ec2:eu-west-1:${local.account_id}:subnet/${local.private_subnet_1_id}"]
    }
    condition {
      test     = "StringEquals"
      variable = "ec2:AuthorizedService"
      values   = ["codebuild.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "codestar-connections:GetConnectionToken",
      "codestar-connections:GetConnection",
      "codeconnections:GetConnectionToken",
      "codeconnections:GetConnection",
      "codeconnections:UseConnection"
    ]
    resources = ["*"]
  }

}

resource "aws_iam_role_policy" "myapp" {
  name   = "code_build_policy"
  role   = aws_iam_role.myapp.name
  policy = data.aws_iam_policy_document.myapp.json
}


#SG
resource "aws_security_group" "codebuild_allow_tls" {
  name        = "codebuild_allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = local.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.codebuild_allow_tls.id
  cidr_ipv4         = local.vpc_cidr
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.codebuild_allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
