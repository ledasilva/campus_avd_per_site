ACTUAL_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

.PHONY: help
help: ## Display help message
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: push
push: ## Push to both repositories
	git push origin 

.PHONY: clean
clean: ## Remove generated files
	rm -rf ./intended/* && \g
	rm -rf ./documentation/*

.PHONY: build
build: ## Generate files
	ansible-playbook ./playbooks/build.yml -i inventory.yml 

.PHONY: build-location
build-location: ## Generate files
	ansible-playbook ./playbooks/build.yml -i $(location)/inventory.yml --extra-vars '{"my_playbook_hosts": $(location)}'

# .PHONY: build-nodocs
# build-nodocs: ## Generate files
# 	ansible-playbook ./playbooks/build.yml -i inventory.yml 

.PHONY: deploy
deploy: ## Deploy configs using new role
	@if [ $(ACTUAL_BRANCH) = "main" ];\
	then\
		ansible-playbook ./playbooks/deploy.yml -i inventory.yml\
	else\
		echo "Trying to deploy to production from non-main branch.";\
	fi\


.PHONY: deploy-selectively
deploy-selectively: ## Deploy configs using new role
	ansible-playbook ./playbooks/deploy.yml -i inventory.yml --extra-vars '{"cv_workspace_description":"Deployed selectively on $(location) using branch: $(ACTUAL_BRANCH)","cv_change_control_name":"Deployed selectively on $(location) using branch: $(ACTUAL_BRANCH)","cv_change_control_description":"Deployed selectively on $(location) using branch: $(ACTUAL_BRANCH)","my_playbook_hosts": $(location)}'

.PHONY: deploy-ignore-branch
deploy-ignore-branch: ## Deploy configs using new role
	ansible-playbook ./playbooks/deploy.yml -i inventory.yml --extra-vars '{"cv_workspace_description":"Deployed using branch: $(ACTUAL_BRANCH)"}'

.PHONY: deploy-force
deploy-force: ## Deploy configs even if a device is not streaming
	ansible-playbook ./playbooks/deploy.yml -i inventory.yml --extra-vars '{"cv_submit_workspace_force":True}'

.PHONY: deploy-debug
deploy-debug: ## Deploy configs using new role
	ansible-playbook ./playbooks/deploy.yml -i inventory.yml -vvv

.PHONY: deploy-force-debug
deploy-force-debug: ## Deploy configs even if a device is not streaming
	ansible-playbook ./playbooks/deploy.yml -i inventory.yml --extra-vars '{"cv_submit_workspace_force":True}' -vvvv

.PHONY: config-commit
config-commit: ## Commit config
	git add intended
	git add documentation
	pre-commit
	git commit -m "Configuration and Documentation generated"

.PHONY: avd-config-commit
avd-config-commit: ## Commit config
	git add group_vars
	git add host_vars
	git add inventory.yml
	pre-commit
	@read -p "Commit message:" message; git commit -m "$$message"

.PHONY: avd-commit-config-build
avd-commit-config-build: ## AVD commit and create config
	git add group_vars
	git add host_vars
	git add inventory.yml
	pre-commit
	@read -p "Commit message:" message; git commit -m "$$message"
	ansible-playbook ./playbooks/generate_config.yml -i inventory.yml --skip-tags validate --vault-password-file ./vault-password.txt
	make config-commit

.PHONY: avd-commit-config-build-deploy
avd-commit-config-build-deploy: ## AVD commit and create config
	git add group_vars
	git add host_vars
	git add inventory.yml
	pre-commit
	@read -p "Commit message:" message; git commit -m "$$message"
	ansible-playbook ./playbooks/generate_config.yml -i inventory.yml --skip-tags validate --vault-password-file ./vault-password.txt
	make config-commit
	make deploy-ignore-branch

.PHONY: commit-config-deploy-force
commit-config-deploy-force: ## Commit configuration and deploy force to cvaas
	git add intended
	git add documentation
	pre-commit
	git commit -m "Configuration and Documentation generated"
	ansible-playbook ./playbooks/deploy.yml -i inventory.yml --extra-vars '{"cv_submit_workspace_force":True}'

