Q=@
DOCKER=docker
COMPOSER=docker-compose
COMPOSITIONS=aifs-network.yml aifs-service.yml
COMPOSE=$(COMPOSER) $(foreach c,$(COMPOSITIONS),-f $(c))
NETWORK=SAFai-network


default: network up

build up down start stop:
	$(Q)$(COMPOSE) $@ 

rebuild: 
	$(Q)$(COMPOSE) down && $(COMPOSE) build --no-cache

connect:
	$(Q)$(COMPOSE) exec evm /bin/bash -i

network:
	$(Q)$(DOCKER) network ls $(NETWORK) >/dev/null 2>&1 || $(DOCKER) network create $(NETWORK) || exit 0

clean: down
	$(Q)$(COMPOSE) rm
	$(Q)$(DOCKER) network rm $(NETWORK)

.PHONY: compose

