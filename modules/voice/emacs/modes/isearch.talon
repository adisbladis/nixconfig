# tag: user.emacs
user.emacs-minor-modes: isearch-mode
-
(forward | for):      user.emacs_isearch_forward()
(backward | back):    user.emacs_isearch_backward()
# TODO: Don't just go forwards, repeat prior
action(user.on_pop):  user.emacs_isearch_forward()
action(user.on_hiss): user.emacs_isearch_backward()
action(user.cancel):  user.emacs_command("isearch-cancel")
