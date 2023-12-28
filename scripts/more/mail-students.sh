#!/bin/bash -ex

((count=0))
while IFS= read -r email
do
	mail -b "dws@developintelligence.com" -F -s 'login info for Terraform course' "${email}" < "tf-user${count}"
	((count=count+1))
done < emails
