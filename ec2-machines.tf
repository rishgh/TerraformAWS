resource "aws_instance" "app" {
  ami                         = "${lookup(var.AmiLinux, var.region)}"
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id                   = "${aws_subnet.PublicAZA.id}"
  vpc_security_group_ids      = ["${aws_security_group.FrontEnd.id}"]
  key_name                    = "${var.key_name}"

  tags {
    Name = "app"
  }

  provisioner "chef" {
    environment     = "_default"
    run_list        = ["cookbook::apache2"]
    node_name       = "app"
    server_url      = "https://my-chefdemo-server-lwpj7v3rsswgxhp9.us-west-2.opsworks-cm.io"
    recreate_client = true
    user_name       = "admin"
    user_key        = "${file("private.pem")}"
    version         = "12.4.1"
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("TerraformTest.pem")}"
}

    # If you have a self signed cert on your chef server change this to :verify_none
    ssl_verify_mode = ":verify_peer"
  }
}
