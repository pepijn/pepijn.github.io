.PHONY: _posts/2018-08-23-real-world-ledger-part-1.md
_posts/2018-08-23-real-world-ledger-part-1.md: org/real-world-ledger-part-1.org
	/usr/local/bin/emacs --script md-export.el "$(realpath $^)" "$(realpath $@)"
	#/usr/local/bin/emacs --no-init-file md-export.el -- "$(realpath $^)"
