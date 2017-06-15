
1 {const_bit(I,B,0..1)} 1 :- op(I,const),bit_index(B).



op(0, mod).

edge(0,1).
edge(0,2).

op(2, const).
op(1,mul).

edge(1,3).
edge(1,4).

op(3, key).
op(4, const).


%key(0..1).
%key(56).
%key(342).
%key(33).
%key(124).
%key(209..251).

key(16715).
key(16716).
key(16722).
key(16723).
key(16730).
key(17217).
key(17231).
key(17236).
key(17475).
key(17477).
key(17996).
key(17997).
key(18241).
key(18261).
key(18505).
key(18753).
key(18756).
key(18764).
key(18766).
key(19283).
key(19289).
key(19521).
key(19777).
key(19780).
key(19781).
key(19784).
key(19785).
key(19790).
key(19791).
key(19792).
key(19795).
key(19796).
key(20035).
key(20036).
key(20037).
key(20040).
key(20042).
key(20045).
key(20054).
key(20057).
key(20296).
key(20299).
key(20306).
key(20545).
key(20562).
key(20567).
key(21065).
key(21315).
key(21316).
key(21582).
key(21592).
key(21844).
key(22081).
key(22089).
key(22100).
key(22337).
key(22345).
key(22358).
key(22361).

%*
key(65906).
key(85162).
key(43530).
key(77141).

key(15426).
key(57633).
key(97824).
key(7369).
key(93849).
key(48831).
key(52260).

*%

%*
key(1211).
key(4385).
key(45712).
key(94605).
key(63098).
key(52838).
key(18933).
key(53879).
key(9101).
key(36649).
key(14083).
key(52051).
key(99332).
key(54566).
key(74284).
key(81844).
key(38252).
key(93398).
key(74199).
key(91393).
key(91706).
key(75228).
key(42676).
key(6639).
key(49375).
key(60143).
key(38506).
key(38901).
key(8977).
key(37772).
key(11225).
key(78246).
key(47486).
key(8696).
key(38604).
key(97067).
key(88660).
key(44525).
key(42227).
key(20956).
key(98595).
key(49557).
key(54299).
key(64750).
key(58239).
key(41848).
key(88840).
key(46925).
key(15745).
key(18775).
key(37166).
key(51182).
key(81464).
key(78387).
key(56119).
key(26706).
key(5174).
key(45570).
key(27027).
key(79482).
key(7161).
key(13343).
key(22306).
key(52449).
key(72179).
key(89256).
key(38432).
key(32677).
key(64181).
key(85512).
key(39542).
key(54493).
key(6706).
key(98780).
key(10999).
key(71072).
key(10606).
key(56076).
key(30152).
key(77394).
key(45577).
key(311).
key(98281).
key(15812).
key(91344).
key(96560).
key(11819).
key(57731).
key(56116).
key(53490).
key(74394).
key(48855).
key(15522).
key(47591).
key(47005).
key(69836).
key(23561).
key(35780).
key(52245).
key(60088).
*%

#script (python)
def bit_values(k,n):
    k = k.number
    n = n.number
    results = []
    for i in range(n):
        b = i
        v = 1 if (1<<i)&k else 0
        results.append((b,v))
    return results
#end.
key_bit(I,B,V) :- key(I), (B,V)=@bit_values(I,bits).