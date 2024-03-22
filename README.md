![Static Badge](https://img.shields.io/badge/Ubuntu-True-blue)
![Static Badge](https://img.shields.io/badge/Windows-Testing-red)
![Static Badge](https://img.shields.io/badge/Language-Emacs_Lisp-purple)
![Static Badge](https://img.shields.io/badge/For-Novice-brown)
---
## 前言：
+ ### 1. 简介：
    这是一个面向新手 ~~我自己~~ 的用于写Rust 和 cpp 的 Emacs 配置，目前只有3个配置文件。
    


    + init.el 包含了最基本的配置和一些修改。
    + lisp/treemacs.el 是treemacs官方配置，~~只修改了两行~~。
    + lisp/rust.el 内容主要来自[参考11][12] 和 [参考12][12]，并使用 tree-sitter 强化了代码高亮。


+ ### 2. 主要插件：

    + lsp-mode 
    + rust-mode / rustic
    + lsp-ui 
    + tree-sitter

+ ### 3. Emacs截图：

![Normal](https://github.com/superbignut/Emacs-SMCM/blob/master/screenshots/normal.png)

![Error](https://github.com/superbignut/Emacs-SMCM/blob/master/screenshots/error.png)

+ ### 4. 配置参考：
    1. Emacs欢迎界面上的Emacs tutorial。包含了Emacs的最基本按键和功能
    2. B站/知乎上的[《Emacs高手修炼手册》][1]一步一步配置出Emacs的基本功能
    3. NykMa个人网站上的[《Emacs 自力求生指南》][2]有他对的Emacs配置的详细说明
    4. 子龙山人的[《21天学会Emacs》][3]
    5. Github的Awesome系列 [awesome-elisp][5]，其中的 [Emacs In A Box - Elisp Programming][6]
    6. 国内的 Emacs圈子 [Emacs-China][4]
    7. 官方的Emacs手册 [GNU Emacs manual][7]
    8. 官方的Elisp参考手册 [Emacs Lisp Reference Manual][8]
    9. 官方的不那么硬核的 [An Introduction to Programming in Emacs Lisp][9]
    10. tuhdo的一系列教程 [Emacs mini manual series][11]，甚至还有Helm教程
    11. Robert Krahn的 [Emacs-Rust][12] 入门级详细配置，包括lsp，rustic，lsp-ui
    12. [Lsp Mode 官网][14] 里面有详细的各种语言的配置和参考链接
    13. [clangd 官网][15] 的说明和 Troubleshooting

+ ### 5. My-Trouble and Debug C++
        
  1. 在配置c++的时候，缺少 json文件导致 Emacs 无法识别项目结构，类似于在vscode中的 json一样。
        
        解决办法在LSP-MODE和CLANGD中都有指出，我是使用CMAKE构建项目的，所以可以直接生成 json文件 :

                cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1

  2. json配置好后，项目结构没问题，但发现系统文件<string>之类都无法被识别。
        解决办法是[Stack Overflow][16] 中提到的:

                $ clang -v
                        Ubuntu clang version 14.0.0-1ubuntu1.1
                        Target: x86_64-pc-linux-gnu
                        Thread model: posix
                        InstalledDir: /usr/bin
                        Found candidate GCC installation: /usr/bin/../lib/gcc/x86_64-linux-gnu/10
                        Found candidate GCC installation: /usr/bin/../lib/gcc/x86_64-linux-gnu/11
                        Found candidate GCC installation: /usr/bin/../lib/gcc/x86_64-linux-gnu/12
                        Found candidate GCC installation: /usr/bin/../lib/gcc/x86_64-linux-gnu/13
                        Selected GCC installation: /usr/bin/../lib/gcc/x86_64-linux-gnu/13
        查看clangd的使用的GCC的版本，Selected 一行中可以看到我这里的是 13，进而安装相应的库:

                sudo apt install libstdc++-13-dev

  3. 对 c++ 进行 debug的话，就回到 vscode中，这里就不在 Emacs 中折腾了，参考 [vscode官网][17]，launch.json 配置如下:


                {
                        "version": "0.2.0",
                        "configurations": [

                        {
                                "name": "My-Debug",
                                "type": "cppdbg",
                                "request": "launch",
                                "program": "${workspaceFolder}/test",   // Change here.
                                "args": [],
                                "stopAtEntry": false, 
                                "cwd": "${workspaceFolder}",            // Change here.
                                "environment": [],
                                "MIMode": "gdb",
                                "setupCommands": [
                                {
                                        "description": "Enable pretty-printing for gdb",
                                        "text": "-enable-pretty-printing",
                                        "ignoreFailures": true
                                },
                                {
                                        "description": "Set Disassembly Flavor to Intel",
                                        "text": "-gdb-set disassembly-flavor intel",
                                        "ignoreFailures": true
                                }
                                ]
                        }
                        ]
                }
        
        值的注意的是，为了编译出可调试的版本，在CMake构建项目时，需要额外的参数而不是单纯的 cmake  ..

                cmake -DCMAKE_BUILD_TYPE=Debug ..

        而 make 和 g++ 则是要 添加 -g

                g++ -g main.cpp -o main

<!-- ### 以下均为在Ubuntu22.04中对Emacs27/29的个人配置和理解
---

        (tool-bar-mode -1)
        (scroll-bar-mode -1)
        关闭工具栏、关闭屏幕右侧滚动条，我觉得工具栏(menu-bar)不仅好看而且有用，所以没关。
        
---
        (show-paren-mode t)
        由于Elsp中括号很多，开启这个会将光标处的"("和")"同时高亮。
---
        (global-display-line-numbers-mode 1)
        开启后，为所有窗口显示行号，但似乎还有其他的开启方法，开启的位置也有区别。
---
        (put 'narrow-to-region 'disabled nil)
        使用"C-x n n"后自动生成，与narrow功能相关，新手可忽略。
---
        (add-to-list 'load-path
                (expand-file-name (concat user-emacs-directory "lisp")))
        连续调用三个函数，完成字符串的连接、把~拓展为家目录和把字符串添加到load-path。
---
上述做法是为了让配置文件更有结构和条理性，但需要结合require和provide函数使用，分三步：
  1. 把写好的abc.el文件放在.emacs.d/lisp/目录下 ~~(当然你的文件的名字可以不是abc)~~
  2. 在abc.el文件中加上,(应该是任意位置都可以):
          
          provide('abc)

  3. 在init.el中加上:
          
          require('abc)
如果对你也对load，require，package-install感到迷惑，除了这三个函数的help文档，GNU Emacs manual的第28.8节[Libraries of Lisp Code for Emacs][10]中也有说明。尤其是最后一段：

>Note that installing a package using package-install (see Package Installation) >takes care of placing the package’s Lisp files in a directory where Emacs will find >it, and also writes the necessary initialization code into your init files, making >the above manual customizations unnecessary.

大致含义就是，对于那些  通过使用package-install安装的包，再对他们require就是unnecessary的了。

---
        (defun open-init-file()
        (interactive)
        (find-file "~/.emacs.d/init.el"))

        (global-set-key (kbd "<f2>") 'open-init-file)
        以上代码来自参考4，首先定义了一个可以交互的函数，可交互在这里指的是是否可以使用"M-x"进行调用,
        与是否可以对它绑定按键。实现的功能就是按F2直接切到init.el，入门必备功能。
---
        (global-set-key (kbd "M-[") 'previous-buffer)
        (global-set-key (kbd "M-]") 'next-buffer)
        切换到上一个buffer和切换到下一个buffer，本来的快捷键要按三个键，很难受。
---

        (setq-default cursor-type 'bar)
        (setq inhibit-startup-screen -1)
        光标改成竖线，关掉开始界面。
---
        (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
        给出自定义文件位置，这样就不会在init.el文件中添加某些自动生成的配置。一般第一天学Emacs都会遇到。
---

        (setq package-archives '(
			 ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
			 ("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
			 ("org" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")))
        首先把包的下载源切到国内，代码来自清华源。

        (require 'package)
        'package是一个build-in的包，所以不require应该也行，这里不确定。

---
        (unless (bound-and-true-p package--initialized)
        (package-initialize))
        猜测，这就应该是GNU Emacs manual的第28.8节说的，加载所有使用package-install安装的包。
        我们只需要初始化一下就行，但只是猜测。

---
        (unless (package-installed-p 'use-package)
        (package-refresh-contents)
        (package-install 'use-package))
        参考别人的解释：类似于先 sudo apt update 再 sudo apt install 'use-package。
---

然后就到了6级，学习我们的大招 ~~ultimate ability~~ ，也就是use-package，但去 Emacs官网首页的最下方可以看到，在 Emacs29.1版本中use-package已经被include 进Emacs。因此在29.1之后的版本，上述代码应该可以被require代替。

对于use-package用法，请看官方README。常用的有init,config,bind,hook这四个。大致功能为load前配置，load后配置，绑定快捷键，绑定hook。

---

        (setq use-package-always-ensure t)
        和关键字:ensure功能一样，保证使用到的包已被安装。
---
下面开始使用use-package进行各种包安装：

        (use-package paredit
        :hook
        (emacs-lisp-mode . paredit-mode)
        (lisp-interaction-mode . paredit-mode))
        使用Paredit可以自动配对和删除()和"",也就是当输入与删除"("时，自动输入与删除")",无法手动删除")"。
        并且绑定了两个hook，分别是，在写lisp时候触发，和在*scratch* buffer中触发。
        但当你输入了一个中文的括号，会有bug。

这里只在lisp的模式下开启了paredit，其实是因为还有一个smartparens插件也有一些与括号有关的操作，lsp也有这部分的功能，所以他们其实是有一些重合的。paredit的[快捷键][13]在emacs-wiki上可以看到：

---
        (use-package rainbow-delimiters
        :hook
        (emacs-lisp-mode . rainbow-delimiters-mode)
        (lisp-interaction-mode . rainbow-delimiters-mode))
        不同的括号对有着不同的颜色。
        hook同上。
---
        (use-package marginalia
        :init
        (marginalia-mode))
        这个包让我最大的感受是在"C-h f"时，能在右侧的margin部分快速扫一眼函数的功能。
        除此之外，它在Github上给出了其他功能，并且更建议和consult一起使用。
---
紧接着请出重量级package:Helm。他的官网给出的定义是：Emacs incremental completion and selection narrowing framework。我还暂时不能理解这句话。但我可以深刻的意识到的地方是，我使用到的功能只是Helm的冰山一角。Helm还有很多地方，有待发掘。

        (use-package helm
        :init
        (helm-mode 1)
        :bind (("M-x" . helm-M-x) ;; 1 执行command
                ("C-x C-f" . helm-find-files);; 2 搜索文件
                ("M-y" . helm-show-kill-ring) ;; 3 列出有哪些“C-k"项，类似于剪切板
                ("C-x b" . helm-mini) ;; 4 这么设置后和5的功能基本是一样的
                ("C-x C-b" . helm-buffers-list) ;; 5 
                ("C-c h o" . helm-occur);; 6 当前文件内搜索
                ("C-c h i" . helm-imenu);; 7 加强版imenu
                ;;helm-man-woman C-c c m ;; 8 可以看linux和Emacs的man手册
                ;; helm-find ;; 9 类似于find
                ("C-c h g" . helm-do-grep-ag))) ;; 10 这个应该是项目内搜索 -->
        
<!-- helm-buffers-list 类似于 “C-x 
helm-occur 当前文件搜索 -->






---
[1]:https://zhuanlan.zhihu.com/p/341512250
[2]:https://nyk.ma/posts/emacs-write-your-own/
[3]:https://space.bilibili.com/292659700?spm_id_from=333.337.search-card.all.click
[4]:https://emacs-china.org/
[5]:https://github.com/p3r7/awesome-elisp
[6]:https://caiorss.github.io/Emacs-Elisp-Programming/Elisp_Programming.html#sec-1-1
[7]:https://www.gnu.org/software/emacs/manual/html_node/emacs/index.html
[8]:https://www.gnu.org/software/emacs/manual/html_node/elisp/index.html
[9]:https://www.gnu.org/software/emacs/manual/html_node/eintr/index.html
[10]:https://www.gnu.org/software/emacs/manual/html_node/emacs/Lisp-Libraries.html
[11]:https://tuhdo.github.io/index.html
[12]:https://robert.kra.hn/posts/rust-emacs-setup/#inline-errors
[13]:https://www.emacswiki.org/emacs/PareditCheatsheet
[14]:https://emacs-lsp.github.io/lsp-mode/tutorials/CPP-guide/
[15]:https://clangd.llvm.org/
[16]:https://stackoverflow.com/questions/26333823/clang-doesnt-see-basic-headers/74759390#74759390
[17]:https://code.visualstudio.com/docs/cpp/launch-json-reference