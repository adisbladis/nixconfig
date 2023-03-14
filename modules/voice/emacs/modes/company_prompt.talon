# tag: user.emacs
user.emacs-minor-mode: company-mode
user.emacs-company-prompt-open: True
-
pick <number>: user.emacs_company_complete(number)
pick (that | thing): user.emacs_command("company-complete")
# Overloading this may get confusing, might be better to have a separate command.
(complete | pleat): user.emacs_command("company-complete")
move <number>: user.emacs_company_highlight(number)
[show] (doc | dock | docs) <number>:
    user.emacs_company_highlight(number)
    user.emacs_command("company-quickhelp-manual-begin")
