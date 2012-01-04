(require 'jaspace)

;; テキストモード時に有効
(add-hook 'text-mode-hook 'jaspace-mode)

;; 全角スペース
(setq jaspace-alternate-jaspace-string "__")

;; 改行
(setq jaspace-alternate-eol-string "<\n")

;; タブ
;(setq jaspace-highlight-tabs t)
;(set-face-background 'jaspace-highlight-tab-face "white")

