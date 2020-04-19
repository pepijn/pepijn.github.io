_posts/%.md: _source/%.md
	cp "$(abspath $<)" "$(abspath $@)"

_posts/%.md: _source/%.org
	_bin/export "$(abspath $<)" "$(abspath $@)"

.PHONY: publish
publish: _posts/2015-10-04-building-a-geojson-travel-log-an-introduction-to-org-mode-and-babel.md \
         _posts/2016-04-20-sidestepping-heroku-limits-with-postgresql-upsert.md \
         _posts/2015-10-13-visualizing-24-hours-of-medical-students-cramming-anatomy.md \
         _posts/2018-08-23-real-world-ledger-part-1.md

.PHONY: build
build: publish
	bash -ic 'JEKYLL_ENV=production bundle exec jekyll build --config _config.yml,_config_production.yml'

deploy: build
	lftp -f _deploy/upload.txt

clean:
	rm _posts/*
