_posts/2018-08-23-real-world-ledger-part-1.md: org/real-world-ledger-part-1.org
	/usr/local/bin/emacs --chdir /tmp --script $(abspath md-export.el) "$(abspath $^)" "$(abspath $@)"
	#/usr/local/bin/emacs --no-init-file md-export.el -- "$(realpath $^)"

build: _posts/2018-08-23-real-world-ledger-part-1.md
	bash -ic 'bundle exec jekyll build'

deploy: build
	lftp -f upload.txt
