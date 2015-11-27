(:
I pledge my honor that all parts of this project were done by me alone and
without collaboration with anybody else.

CSE532 -- Project 3
File name: query4.xquery
Author: Xinhe Huang (108390641)
Brief description: query4
:)

xquery version "3.0";
declare default element namespace "http://localhost:8080/exist/CCDB";
declare function local:indirectuser($direct as element()*,$indirect as element()*) as element()*
{
  let $CCDB := doc("/db/CCDB/CCDB.xml")/CCDB
  let $t1:=
    for $d in $direct//direct,
        $i in $indirect//indirect,
        $c in $CCDB//Card
    where $d/CId=$c/CId
          and $c/Owner=$i/PId
    return 
      <indirect>
          {$d/PId}
          {$i/CId}
      </indirect>
     
  let $t2:=
     for $d in $direct//direct
      return 
      <indirect>
          {$d/PId}
          {$d/CId}
      </indirect>
   
  let $t4:=  <a>{$t1 union $t2}</a>
  let $t3:=
    for $d in distinct-values($t4//indirect/PId),
        $c in distinct-values($t4//indirect[PId = $d]/CId)
    return 
      <indirect>
          <PId>{$d}</PId>
          <CId>{$c}</CId>
      </indirect>
  
  return
    if (count($t3)>count($indirect//indirect))
      then
         local:indirectuser($direct,<indirectuser>{$t3}</indirectuser>)
     else
         $t3
};
      
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
   <query4>
       {
        let $direct:=
          <directusers>
          {
            for $a in  $authusers//authuser
            return
               <direct>
                   {$a/PId}
                   {$a/CId}
              </direct>
          }
          </directusers>
                   
        let $indirect:=
        <indirectusers>{
          for $a in  $authusers//authuser
          return
            <indirect>
              {$a/PId}
              {$a/CId}
            </indirect>
         }
        </indirectusers>
        
        let $res:=<res>{local:indirectuser($direct,$indirect)}</res>
        
        return  
         for $x in $res//indirect
         return
            <result>
              {$x/PId}
              {$x/CId}
            </result>
      }
  </query4>
   
 