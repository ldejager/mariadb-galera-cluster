ANBIN = ansible-playbook
ANSIBLE = $(ANBIN) $(ANFLAGS)
TFBIN = terraform
TERRAFORM = $(TFBIN) $(TFLAGS)

.PHONY: all plan apply destroy update deploy

all: plan apply deploy

terraform.tfplan: *.tf
	$(TERRAFORM) plan -out $@

update:
	$(TERRAFORM) get -update

plan: update terraform.tfplan

apply:
	terraform apply

destroy:
	$(TERRAFORM) plan -destroy -out terraform.tfplan
	$(TERRAFORM) apply terraform.tfplan

deploy:
	$(ANSIBLE) -v --private-key ~/.ssh/id_rsa -i ~/bin/terraform-inventory provisioning/terraform.yml

clean:
	rm -f terraform.tfplan
	rm -f terraform.tfstate
	rm -fR .terraform/
	rm -f terraform.tfstate.backup
