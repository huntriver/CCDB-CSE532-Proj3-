(:
I pledge my honor that all parts of this project were done by me alone and
without collaboration with anybody else.

CSE532 -- Project 3
File name: query1.xquery
Author: Xinhe Huang (108390641)
Brief description: query1
:)

xquery version "3.0";
declare default element namespace "http://localhost:8080/exist/CCDB";

let $CCDB := doc("/db/CCDB/CCDB.xml")/CCDB
return
  <query1>{
    for $o in $CCDB//Organization,
        $p1 in $CCDB//Person,
        $p2 in $CCDB//Person,
        $c in $CCDB//Card,
        $s in $o//Signer,
        $a in $c//AuthorizedUser
    where 
      $c/Limit - $c/Balance<1000
      and $c/Owner=$o/OId
      and $a=$p1/PId
      and $s=$p2/PId
    return 
      <result>
        <user>{$p1/PId} {$p1/PersonName}</user>
        <signer>{$p2/PId} {$p2/PersonName}</signer>
      </result>
  }
  </query1>
    