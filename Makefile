.PHONY: test
test:
	@docker-compose -f docker/docker-compose.yml up -d
	@julia --project=@. -e "using Pkg; Pkg.test()"
	@docker-compose -f docker/docker-compose.yml down --remove-orphans
	@docker image rm redislabs/redisearch:2.0.0