_posts/2015-10-13-visualizing-24-hours-of-medical-students-cramming-anatomy.md: org/visualizing-24-hours-of-medical-students-cramming-anatomy.org
	bin/export "$(abspath $<)" "$(abspath $@)"

_posts/2016-04-20-sidestepping-heroku-limits-with-postgresql-upsert.md: org/upsert-scraper.org
	bin/export "$(abspath $<)" "$(abspath $@)"

_posts/2018-08-23-real-world-ledger-part-1.md: org/real-world-ledger-part-1.org
	bin/export "$(abspath $<)" "$(abspath $@)"

publish: _posts/2016-04-20-sidestepping-heroku-limits-with-postgresql-upsert.md \
         _posts/2015-10-13-visualizing-24-hours-of-medical-students-cramming-anatomy.md \
         _posts/2018-08-23-real-world-ledger-part-1.md

.PHONY: build
build: publish
	bash -ic 'JEKYLL_ENV=production bundle exec jekyll build --config _config.yml,_config_production.yml'

deploy: build
	lftp -f deploy/upload.txt

