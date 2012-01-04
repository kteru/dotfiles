;; load-path
(setq load-path (append
    '("~/.emacs.d"
      "~/.emacs.d/lisp")
    load-path))

;; 分割設定ロード
(load "init-lang")
(load "init-general")
(load "init-defuns")
(load "init-key")

;; 自分で導入した *.el の設定
(load "config-jaspace")

