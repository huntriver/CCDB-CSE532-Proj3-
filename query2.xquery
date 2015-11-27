(:
I pledge my honor that all parts of this project were done by me alone and
without collaboration with anybody else.

CSE532 -- Project 3
File name: query2.xquery
Author: Xinhe Huang (108390641)
Brief description: query2
:)

xquery version "3.0";
declare default element namespace "http://localhost:8080/exist/CCDB";

let $CCDB := doc("/db/CCDB/CCDB.xml")/CCDB
let $authusers:=
  <authusers> 
    {
      for $p in $CCDB//Person,
          $c in $CCDB//Card,
          $a in $c//AuthorizedUser
      where $p/PId=$a
      return 
        <authuser>
          {$p/PId} {$c/CId}
        </authuser>
    }
    
    {
      for $p in $CCDB//Person,
          $c in $CCDB//Card,
          $o in $CCDB//Organization,
          $s in $o//Signer
      where $p/PId=$s and
            $o/OId=$c/Owner
      return 
          <authuser>
              {$p/PId} {$c/CId}
          </authuser>
        }
  </authusers>
  
return
  <query2>
  {
    for $p in $CCDB//Person
    let $a:= $authusers//authuser[PId=$p/PId]  
    where count($p//OwnedCard)>=4
          and count($a)>=3
    return
      <result>
       {$p/PId} {$p/PersonName}
      </result>
    
   }
  </query2>
 