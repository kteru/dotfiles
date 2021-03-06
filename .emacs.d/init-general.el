;;------------------------------
;; display
;;------------------------------

;; メニューバーを消す
(menu-bar-mode -1)

;; カーソル位置を表示
(line-number-mode t)
(column-number-mode t)

;; フォント色付け
(global-font-lock-mode t)

;; 対応する括弧を光らせる
(show-paren-mode t)

;; リージョンをハイライト
(transient-mark-mode t)

;; I-search 終了後もハイライト
(setq isearch-lazy-highlight-cleanup nil)

;; 行末スペース表示
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "cyan")

;; 行番号表示
(require 'linum)
(setq linum-format "%4d |")


;;------------------------------
;; behavior
;;------------------------------

;; インデントは半角スペース
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'tab-to-tab-stop)
(setq-default tab-width 4)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120 124 128 132 136 140 144 148 152))

;; バックアップファイルを作成しない
(setq backup-inhibited t)

;; オートセーブファイルの保存先変更
(setq auto-save-file-name-transforms
    `((".*" ,(expand-file-name "~/.emacs.d/var/") t)))

;; 終了時にオートセーブファイルを削除する
(setq delete-auto-save-files t)

;; y/n
(fset 'yes-or-no-p 'y-or-n-p)

;; スクロール量
(setq scroll-step 1)

;; 補完時に大文字小文字を区別しない
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;; 前回のカーソル位置を記憶
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file "~/.emacs.d/var/.emacs-places")

;; narrow-to-region
(put 'narrow-to-region 'disabled nil)

;; cperl-mode
(defalias 'perl-mode 'cperl-mode)
(add-hook 'cperl-mode-hook
    '(lambda () (cperl-set-style "PerlStyle")))

