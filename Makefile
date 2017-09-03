Q=@
DOCKER=docker
COMPOSER=docker-compose
COMPOSITIONS=aifs-network.yml
COMPOSE=$(COMPOSER) $(foreach c,$(COMPOSITIONS),-f $(c))
NETWORK=SAFai-network


default: create-network up

build up down start stop:
	$(Q)$(COMPOSE) $@ 

create-network:
	$(Q)$(DOCKER) network ls $(NETWORK) >/dev/null 2>&1 || $(DOCKER) network create $(NETWORK) || exit 0

clean: down
	$(Q)$(COMPOSE) rm
	$(Q)$(DOCKER) network rm $(NETWORK)

.PHONY: compose

