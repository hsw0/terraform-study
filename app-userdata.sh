#!/bin/bash

yum install -y nginx
service nginx start
chkconfig nginx on
