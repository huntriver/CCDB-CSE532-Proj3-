(:
I pledge my honor that all parts of this project were done by me alone and
without collaboration with anybody else.

CSE532 -- Project 3
File name: query3.xquery
Author: Xinhe Huang (108390641)
Brief description: query3
:)

xquery version "3.0";
declare default element namespace "http://localhost:8080/exist/CCDB";

let $CCDB := doc("/db/CCDB/CCDB.xml")/CCDB
return
  <query3>
    {
       let $pp:=
       <PersonWhoHasACardLimitsAbove25000>{
        for $p in $CCDB//Person
        let $cc:=
             for $c1 in $p/OwnedCard
             let $c2:= $CCDB//Card[CId=$c1]
             where $c2/Limit>=25000
             return $c1
         
        where 
            not (exists($cc))
        return 
             $p
       }
       </PersonWhoHasACardLimitsAbove25000>
   
        let $oo:=
        <OrgsWhoHaveASignerInAboveSet>{
          for $o in $CCDB//Organization,
              $s in $o//Signer,
              $x in $pp//Person
          where $x/PId=$s
          return $o
       }
       </OrgsWhoHaveASignerInAboveSet>
     
       for 
         $o in $CCDB//Organization
       let $o2:=
         for  $o1 in $oo//Organization
         where
            $o1/OId=$o/OId
         return $o
      where not(exists($o2))
      return 
         for $c in $o/OwnedCard
         let $c2:=$CCDB//Card[CId=$c]
         return <result>
             {$c2/CId}
             </result>
    }
  </query3>
 