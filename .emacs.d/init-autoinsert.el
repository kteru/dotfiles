(require 'autoinsert)

;; テンプレート配置ディレクトリ
(setq auto-insert-directory "~/.emacs.d/template")

;; テンプレートリスト
(setq auto-insert-alist
    (nconc '(
        ("\\.sh$" . "sh")
        ("\\.rb$" . "rb")
        ("\\.pl$" . "pl")
        ("\\.pm$" . "pm")
        ) auto-insert-alist))

;; 新規作成時に実行
(add-hook 'find-file-not-found-hooks 'auto-insert)

