---
layout: post
title: 用emacs的org-mode编写与发布jekyll的blog文章
date: 2017-08-13
description: 用emacs的org-mode编写与发布jekyll的blog文章
tags:
 - 机器学习
excerpt_separator: <!--more-->
---

## 随便说说

最近开始玩起emacs起来. 因为一直比较好奇, 还有他的elisp也是很好地lisp方言, 并希望能借助使用emacs的时候, 运用一下非常正统lisp方言写些小东西. 另外是因为知道了[spacemacs](https://github.com/syl20bnr/spacemacs) 这个东西的存在. 

开始上手emacs后, 到处都在说org-mode, 然后了解了一下, 发现这不就是markdown的升级版么. 然后想, 我的jekyll弄的blog用的markdown, 能不能替换成org呢. 

网上查了一下, 发现github.io不是原生支持org的. 而jekyll的可以通过插件形式实现org. 于是倒腾了一阵子, 终于可以在jekyll上用org些博客并推到github.io上了

## 参考文献

1) [jekyll-org插件](https://github.com/eggcaker/jekyll-org)
2) [使用org-mode撰写jekyll博客](https://jsuper.github.io/emacs/using-org-mode-to-write-jekyll-post.html)
3) [org-mode使用手册, 需要经常看看](https://github.com/marboo/orgmode-cn/blob/master/org.org)
