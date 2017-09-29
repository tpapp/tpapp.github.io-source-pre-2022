+++
date = 2017-08-28T14:41:58+02:00
draft = false
title = "Emacs customizations for julia-mode"
slug = ""
categories = [""]
tags = ["julia", "emacs"]
+++

I find the following customizations very useful for *editing* Julia
code in Emacs. Add them to `julia-mode-hook`, eg
```emacs-lisp
(defun customize-julia-mode ()
  "Customize julia-mode."
  (interactive)
  ;; my customizations go here
  )

(add-hook 'julia-mode-hook 'customize-julia-mode)
```

## Highlight FIXME/TODO/...

When I just want to note something in a comment for future reference,
I prefer to have certain words highlighted. You can use something like
this:

```emacs-lisp
(font-lock-add-keywords nil
                        '(("\\<\\(FIXME\\|TODO\\|QUESTION\\|NOTE\\)"
                        1 font-lock-warning-face t)))
```

This is what it looks like:

<pre style="color: #262626; background-color: #ded6c5;">
            chklapackerror<span style="color: #262626;">(</span>info<span style="color: #262626;">[])</span>
            <span style="color: #2020cc; font-weight: bold;">if</span> any<span style="color: #262626;">(</span>ifail .!= 0<span style="color: #262626;">)</span>
                <span style="color: #008b45;"># </span><span style="color: #f71010; font-weight: bold;">TODO</span><span style="color: #008b45;">: better error message / type
</span>                error<span style="color: #262626;">(</span><span style="color: #fa5151;">"failed to converge eigenvectors:\n$(nonzeros(ifail))"</span><span style="color: #262626;">)</span>
            <span style="color: #2020cc; font-weight: bold;">end</span>
</pre>

## Highlight symbols

After
```emacs-lisp
(require 'highlight-symbol)
```
add a hook for
```emacs-lisp
(local-set-key [(control ?c) ?s] 'highlight-symbol-at-point)
(local-set-key [(control ?c) ?n] 'highlight-symbol-next)
(local-set-key [(control ?c) ?p] 'highlight-symbol-prev)
```
This highlights symbols with `C-c s`:

<pre style="color: #262626; background-color: #ded6c5;">
<span style="color: #2020cc; font-weight: bold;">function</span> <span style="color: #2c53ca;">issymmetric</span><span style="color: #262626;">(</span><span style="color: #000000; background-color: #ffff00;">A</span><span style="color: #262626; background-color: #ded6c5;">::</span><span style="color: #9400d3;">AbstractMatrix</span><span style="color: #262626;">)</span>
    indsm, indsn = indices<span style="color: #262626;">(</span><span style="color: #000000; background-color: #ffff00;">A</span><span style="color: #262626;">)</span>
    <span style="color: #2020cc; font-weight: bold;">if</span> indsm != indsn
        <span style="color: #2020cc; font-weight: bold;">return</span> <span style="color: #259ea2;">false</span>
    <span style="color: #2020cc; font-weight: bold;">end</span>
    <span style="color: #2020cc; font-weight: bold;">for</span> i = first<span style="color: #262626;">(</span>indsn<span style="color: #262626;">)</span>:last<span style="color: #262626;">(</span>indsn<span style="color: #262626;">)</span>, j = <span style="color: #262626;">(</span>i<span style="color: #262626;">)</span>:last<span style="color: #262626;">(</span>indsn<span style="color: #262626;">)</span>
        <span style="color: #2020cc; font-weight: bold;">if</span> <span style="color: #000000; background-color: #ffff00;">A</span><span style="color: #262626;">[</span>i,j<span style="color: #262626;">]</span> != transpose<span style="color: #262626;">(</span><span style="color: #000000; background-color: #ffff00;">A</span><span style="color: #262626;">[</span>j,i<span style="color: #262626;">])</span>
            <span style="color: #2020cc; font-weight: bold;">return</span> <span style="color: #259ea2;">false</span>
        <span style="color: #2020cc; font-weight: bold;">end</span>
    <span style="color: #2020cc; font-weight: bold;">end</span>
    <span style="color: #2020cc; font-weight: bold;">return</span> <span style="color: #259ea2;">true</span>
<span style="color: #2020cc; font-weight: bold;">end</span>
</pre>

## Fill docstrings

This is useful if you want to use `M-q` on docstrings.

```emacs-lisp
(defun julia-fill-string ()
  "Fill a docstring, preserving newlines before and after triple quotation marks."
  (interactive)
  (if (and transient-mark-mode mark-active)
      (fill-region (region-beginning) (region-end) nil t)
    (cl-flet ((fill-if-string ()
                              (when (or (looking-at (rx "\"\"\""
                                                        (group
                                                         (*? (or (not (any "\\"))
                                                                 (seq "\\" anything))))
                                                        "\"\"\""))
                                        (looking-at (rx "\""
                                                        (group
                                                         (*? (or (not (any "\\"))
                                                                 (seq "\\" anything))))
                                                        "\"")))
                                (let ((start (match-beginning 1))
                                      (end (match-end 1)))
                                  ;; (ess-blink-region start end)
                                  (fill-region start end nil nil nil)))))
      (save-excursion
        (let ((s (syntax-ppss)))
          (when (fourth s) (goto-char (ninth s))))
        (fill-if-string)))))
```

Add
```emacs-lisp
(local-set-key (kbd "M-q") 'julia-fill-string)
```
to the mode hook.

## Highlight things after column 80

I add this to the mode hook:

```emacs-lisp
(set-fill-column 80)
```

I also use `whitespace` globally:

```emacs-lisp
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)
```

This is what it looks like:

<pre style="color: #262626; background-color: #ded6c5;">
    QR<span style="color: #262626;">{</span>T,S<span style="color: #262626;">}(</span>factors<span style="color: #262626; background-color: #ded6c5;">::</span><span style="color: #9400d3;">AbstractMatrix</span><span style="color: #262626;">{</span>T<span style="color: #262626;">}</span>, &#964;<span style="color: #262626; background-color: #ded6c5;">::</span><span style="color: #9400d3;">Vector</span><span style="color: #262626;">{</span>T<span style="color: #262626;">})</span> where <span style="color: #262626;">{</span>T,S<span style="color: #262626; background-color: #ded6c5;">&lt;:</span><span style="color: #9400d3;">AbstractMatrix</span><span style="color: #262626; background-color: #f6f0e1;">}</span><span style="background-color: #f6f0e1;"> = new</span><span style="color: #262626; background-color: #f6f0e1;">(</span><span style="background-color: #f6f0e1;">factors, &#964;</span><span style="color: #262626; background-color: #f6f0e1;">)</span>
<span style="color: #2020cc; font-weight: bold;">end</span>
QR<span style="color: #262626;">(</span>factors<span style="color: #262626; background-color: #ded6c5;">::</span><span style="color: #9400d3;">AbstractMatrix</span><span style="color: #262626;">{</span>T<span style="color: #262626;">}</span>, &#964;<span style="color: #262626; background-color: #ded6c5;">::</span><span style="color: #9400d3;">Vector</span><span style="color: #262626;">{</span>T<span style="color: #262626;">})</span> where <span style="color: #262626;">{</span>T<span style="color: #262626;">}</span> = QR<span style="color: #262626;">{</span>T,typeof<span style="color: #262626;">(</span>factors<span style="color: #262626;">)}(</span>f<span style="background-color: #f6f0e1;">actors, &#964;</span><span style="color: #262626; background-color: #f6f0e1;">)</span>
</pre>

## Hungry delete-mode

Add this to the mode hook:
```emacs-lisp
(hungry-delete-mode)
```
and then backspace and delete will remove all whitespace near the point in the relevant direction.

In case you are wondering, the theme is [alect-light](https://github.com/alezost/alect-themes).
