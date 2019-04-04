|%
+$  move  [bone card]
+$  card
  $%  [%poke wire dock pear]
      [%wait wire @da]
      [%rest wire @da]
      [%info wire toro:clay]
  ==
::
+$  pear
  $%  [%noun cord]
      [%helm-hi cord]
  ==
::
+$  state
  $:  scanning=_|                        :: are we currently scanning?
      filter=(set ship)                  :: set of ships to exlcude from scan 
      configured=(set ship)              :: set of ships to scan
      outstanding=(map ship @da)         :: ships we've |hi'd with no reply
      log=(map ship (list [@da @da]))    :: log of past |hi's sent/recv by ship
      timers=(map wire @da)              :: map of delay timers
      moves=(list move)                  :: list of outgoing moves
  ==
::
--
|_  [bol=bowl:gall sty=state]
::
++  this  .
::
++  abet
  ^-  (quip move _this)
  [moves.sty this(moves.sty ~)]
::
++  prep
  |=  old=(unit state)
  ^-  (quip move _this)
  ?~  old
    :-  [ost.bol %wait /update-scry (add now.bol ~m20)]~
    %=    this
    ::
        scanning.sty  %.n
    ::
        filter.sty    ~
    ::
        configured.sty    
      .^((set ship) %j /(scot %p our.bol)/ships-with-deeds/(scot %da now.bol))
    ==
  [~ this(sty u.old)]
::
++  poke-noun
  |=  a=*
  ^-  (quip move _this)
  ?+  a
    [~ this]
  ::
      %running
    ~&  scanning.sty
    [~ this]
  ::
      %print
    ~&  sty
    [~ this]
  ::
      %start
    =.  this  this(scanning.sty &)
    ::
    =/  ships=(set ship)  (~(dif in configured.sty) filter.sty)
    =.  this  (scan ~(tap in ships))
    ~&  outstanding.sty
    abet
  ::
      %stop
    :_  this(scanning.sty |, timers.sty ~)
    %-  ~(rep by timers.sty)
    |=  [[wir=wire d=@da] mov=(list move)]
    ^-  (list move)
    [[ost.bol %rest wir d] mov]
  ::
      %flush
    [~ this(log.sty ~)]
  ::
      %save
    =/  jon=json
      :-  %o
      %-  ~(rep by log.sty) 
      |=  [[who=ship log=(list [@da @da])] out=(map @t json)]
      =/  arr=json
        :-  %a
        %+  turn  log
        |=  [sent=@da recv=@da]
        ^-  json
        %-  pairs:enjs:format
        :~  [%sent (time:enjs:format sent)]
            [%recv (time:enjs:format recv)]
        ==
      =/  name=@t  (scot %p who)
      (~(put by out) name arr)
    ::
    =/  pax=path  (en-beam:format byk.bol(r [%da now.bol]) /json/tracker)
    =/  cay=cage  [%json !>(jon)]
    :_  this
    [ost.bol %info /save (foal:space:userlib pax cay)]~
  ::
  ==
::
++  ping
  |=  her=ship
  ^+  this
  %=  this
  ::
      moves.sty
    :_  moves.sty
    :*  ost.bol  
        %poke
        /ping/(scot %p her)/(scot %da now.bol)
        [her %hall]  %noun  'fdsjfk'
    ==
  ::
      outstanding.sty
    (~(put by outstanding.sty) her now.bol)
  ==
::
++  scan
  |=  ships=(list ship)
  ^+  this
  |-  
  ?~  ships  
    this
  =.  this  (ping i.ships)
  $(ships t.ships)
::
++  coup
  |=  [wir=wire err=(unit tang)]
  ^-  (quip move _this)
  ?>  ?=([%ping @t @t ~] wir)
  ::
  =/  who=@p   (slav %p i.t.wir)
  =/  wen=@da  (slav %da i.t.t.wir)
  =/  out=@da  (~(got by outstanding.sty) who)
  ?>  =(wen out)
  ::
  =/  old-log=(unit (list [@da @da]))
    (~(get by log.sty) who)
  ::
  =/  new-log=(list [@da @da])
    ?~  old-log  [[wen now.bol] ~]
    [[wen now.bol] u.old-log]
  ::
  =.  outstanding.sty  (~(del by outstanding.sty) who)
  ::
  ?.  scanning.sty
    [~ this]
  ::
  =/  timeout=@da  (add now.bol ~m20)
  =/  wait-wire=wire  /wait/[i.t.wir]/(scot %da timeout)
  :-  [ost.bol %wait wait-wire timeout]~
  %=  this
  ::
      log.sty
    (~(put by log.sty) who new-log)
  ::
      timers.sty
    (~(put by timers.sty) wait-wire timeout)
  ::
  ==
::
++  wake
  |=  [wir=wire ~]
  ^-  (quip move _this)
  ?+    wir
    [~ this]
  ::
      [%update-scry ~]
    =/  scry-result=(set ship)
      .^((set ship) %j /(scot %p our.bol)/ships-with-deeds/(scot %da now.bol))
    ::
    =/  conf-diff=(set ship)
      (~(dif in scry-result) configured.sty)
    ::
    =/  new-pings=(set ship)
      (~(dif in conf-diff) filter.sty)
    ::
    =.  moves.sty
      :_  moves.sty
      [ost.bol %wait /update-scry (add now.bol ~m20)]
    ::
    =.  configured.sty  scry-result
    ::
    abet:(scan ~(tap in new-pings))
  ::
      [%wait @t @t ~]
    =/  who=@p   (slav %p i.t.wir)
    =/  wen=@da  (slav %da i.t.t.wir)
    =.  timers.sty  (~(del by timers.sty) wir)
    ?:  scanning.sty
      abet:(ping who)
    [~ this]
  ==
--
