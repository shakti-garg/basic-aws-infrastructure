data "template_file" "user_data_airflow_webserver" {
  template = "${file("${path.module}/scripts/app_start.sh")}"

  vars = {
    aws_region="${var.region}"
    metadata_db_password_parameter = "${var.rds_snapshot_password_parameter}"
    metadata_db_endpoint = "${aws_db_instance.airflow_postgres.endpoint}"
  }
}

resource "aws_instance" "airflow" {
  ami                    = "${data.aws_ami.amazon_linux_2.image_id}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${var.subnet_ids[0]}"

  key_name               = "${var.ec2_key_pair}"
  vpc_security_group_ids = ["${aws_security_group.airflow.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.airflow.name}"

  user_data               = "${data.template_file.user_data_airflow_webserver.rendered}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "airflow-${var.deployment_identifier}"
    )
  )}"

  # TODO: Remove this once we have dedicated airflow AMI
  lifecycle {
    ignore_changes = ["ami"]
  }
}

