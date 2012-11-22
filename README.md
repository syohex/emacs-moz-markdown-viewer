# moz-markdown-viewer.el

## Introduction
`moz-markdown-viewer.el` is markdown viewer with [mozrepl](https://github.com/bard/mozrepl)
and [Github Markdown API](http://developer.github.com/v3/markdown/).

## Requirements

* Emacs 22 or higher
* Firefox
* MozRepl, Add on for Firefox
* [moz.el](https://github.com/bard/mozrepl/blob/master/chrome/content/moz.el)


## Basic Usage

1. Launch Firefox and start MozRepl

2. Call `M-x moz-markdown-viewer:setup` in your Emacs.

3. Call `M-z moz-markdown-viewer:render` for rendering markdown document.

4. Check firefox and rendered markdown


## Sample Configuration

```` elisp
(require 'moz-markdown-viewer)

(define-key markdown-mode-map (kbd "C-c C-r") 'moz-markdown-viewer:render)
````
