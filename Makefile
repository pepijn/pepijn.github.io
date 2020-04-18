_posts/2018-08-23-real-world-ledger-part-1.md: org/real-world-ledger-part-1.org \
                                               deploy/md-export.el
	/usr/local/bin/emacs --chdir /tmp --script $(abspath deploy/md-export.el) "$(abspath $<)" "$(abspath $@)"
	#/usr/local/bin/emacs --no-init-file md-export.el -- "$(realpath $^)"

.PHONY: build
build: _posts/2018-08-23-real-world-ledger-part-1.md
	bash -ic 'JEKYLL_ENV=production bundle exec jekyll build --config _config.yml,_config_production.yml'

deploy: build
	lftp -f deploy/upload.txt
