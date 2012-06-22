TDCar
=====

What's this?
------------
TD法による強化学習の実装です．

自動車の簡単な物理シミュレーションを行い，一定の範囲内を走りまわるようにSarsaとQ-Learningで学習させます．

動作環境
--------
Ruby1.9.3p194で動作確認しています．

動作にはRuby/SDLが必要です．
また， SDL_ttf_ と |SGE|_ に依存しているので，これらのライブラリを入れてからrubysdl gemを導入してください．

実行方法
--------
120行目のフォントパスと132行目の学習アルゴリズム(Sarsa,Q-Learning)を変更してからtest.rbを実行してください．

10000ステップごとにQ値のログファイルを吐きます．
Sキーを押しても同様です．

このファイルは起動時引数として渡すことで，その状態から学習を開始することができます．

Qを押すと終了します．

.. _SDL_ttf: http://www.libsdl.org/projects/SDL_ttf/
.. |SGE| replace:: SGE(SDL Graphics Extension)
.. _SGE: http://www.digitalfanatics.org/cal/sge/index.html
