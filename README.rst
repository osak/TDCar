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
./test.rbを実行してください．
設定可能な項目は./test.rb --helpを見てください．

Qを押すと終了します．

.. _SDL_ttf: http://www.libsdl.org/projects/SDL_ttf/
.. |SGE| replace:: SGE(SDL Graphics Extension)
.. _SGE: http://www.digitalfanatics.org/cal/sge/index.html
